package code.salecar.controller.admin.order;

import code.salecar.dao.OrderDAO;
import code.salecar.model.Order;
import code.salecar.model.KetManagement.Hash;
import code.salecar.config.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.X509EncodedKeySpec;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Base64;
import java.util.List;

@WebServlet(name = "OrderAdmin", value = "/orderAdmin")
public class OrderAdmin extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderDAO ordDAO = new OrderDAO();
        Hash hashTool = new Hash();
        List<Order> lstOrder = ordDAO.getAllOrders();

        try (Connection conn = DBConnection.getConnection()) {
            for (Order ord : lstOrder) {

                // kiểm tra thời gian lộ khóa
                Timestamp keyRevokedAt = null;
                String userQuery = "SELECT key_revoked_at FROM users WHERE id = ?";
                try (PreparedStatement psUser = conn.prepareStatement(userQuery)) {
                    psUser.setInt(1, ord.getUserId());
                    ResultSet rsUser = psUser.executeQuery();
                    if (rsUser.next()) {
                        keyRevokedAt = rsUser.getTimestamp("key_revoked_at");
                    }
                }

                if (keyRevokedAt != null && ord.getOrderDate().after(keyRevokedAt)) {
                    ord.setSignatureStatus("KEY_REVOKED");
                    ord.setServerHash("N/A - KHÓA ĐÃ HỦY");
                    ord.setDecryptedHash("Cảnh báo an ninh: Khóa bí mật đã báo hủy trước khi tạo hóa đơn này!");
                    continue;
                }

                //  đối xoát chữ kí
                String rawData =  "&userId=" + ord.getUserId() +
                                "&address=" + ord.getShippingAddress() +
                                "&total=" + ord.getTotalAmount();

                String serverHashHex = hashTool.checkSum(rawData, "SHA-256");
                ord.setServerHash("SHA256: " + serverHashHex);

                if (ord.getSignature() == null || ord.getPublicKey() == null || ord.getSignature().trim().isEmpty()) {
                    ord.setSignatureStatus("TAMPERED");
                    ord.setDecryptedHash("Hệ thống phát hiện đơn hàng không có chữ ký số xác thực!");
                    continue;
                }
                // Gọi hàm verify nhận diện thuật toán
                boolean isIntegrityValid = verifySignature(rawData, ord.getSignature(), ord.getPublicKey());

                if (isIntegrityValid) {
                    ord.setSignatureStatus("VALID");
                    ord.setDecryptedHash("SHA256: " + serverHashHex + " (DỮ LIỆU TOÀN VẸN)");
                } else {
                    ord.setSignatureStatus("TAMPERED");
                    ord.setDecryptedHash("CẢNH BÁO: Mã đối soát không khớp! Dữ liệu hóa đơn đã bị chỉnh sửa.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("orders", lstOrder);
        request.getRequestDispatcher("/admin/order-admin.jsp").forward(request, response);
    }

    // Thuật toán giải mã và xxacs thực
    private boolean verifySignature(String data, String signatureBase64, String publicKeyPEM) {
        try {
            String cleanKey = publicKeyPEM
                    .replace("-----BEGIN PUBLIC KEY-----", "")
                    .replace("-----END PUBLIC KEY-----", "")
                    .replaceAll("\\s+", "");

            byte[] keyBytes = Base64.getDecoder().decode(cleanKey);
            X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);

            PublicKey publicKey = null;
            String detectedAlgo = "RSA";

            // phân tích địng dạng khóa
            try {
                KeyFactory kf = KeyFactory.getInstance("RSA");
                publicKey = kf.generatePublic(spec);
                detectedAlgo = "RSA";
            } catch (Exception e) {
                KeyFactory kf = KeyFactory.getInstance("EC");
                publicKey = kf.generatePublic(spec);
                detectedAlgo = "EC";
            }

            byte[] sigBytes = Base64.getDecoder().decode(signatureBase64);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);

            if ("RSA".equals(detectedAlgo)) {
                try {
                    Signature sig = Signature.getInstance("SHA256withRSA");
                    sig.initVerify(publicKey);
                    sig.update(dataBytes);
                    if (sig.verify(sigBytes)) {
                        return true;
                    }
                } catch (Exception e) {
                }

                // Nếu người dùng chọn RSA-PSS trên UI
                try {
                    Signature sig = Signature.getInstance("RSASSA-PSS");
                    java.security.spec.MGF1ParameterSpec mgf1Spec = java.security.spec.MGF1ParameterSpec.SHA256;
                    java.security.spec.PSSParameterSpec pssSpec = new java.security.spec.PSSParameterSpec(
                            "SHA-256", "MGF1", mgf1Spec, 32, 1
                    );
                    sig.setParameter(pssSpec);
                    sig.initVerify(publicKey);
                    sig.update(dataBytes);
                    return sig.verify(sigBytes);
                } catch (Exception e) {
                    return false;
                }

            } else if ("EC".equals(detectedAlgo)) {
                // Nếu người dùng chọn ECDSA trên UI
                try {
                    Signature sig = Signature.getInstance("SHA256withECDSA");
                    sig.initVerify(publicKey);
                    sig.update(dataBytes);
                    return sig.verify(sigBytes);
                } catch (Exception e) {
                    return false;
                }
            }

            return false;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}