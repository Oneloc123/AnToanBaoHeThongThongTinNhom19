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
                String rawData = "id=" + ord.getId() +
                        "&userId=" + ord.getUserId() +
                        "&address=" + ord.getShippingAddress() +
                        "&total=" + ord.getTotalAmount();

                String serverHashHex = hashTool.checkSum(rawData, "SHA-256");
                ord.setServerHash("SHA256: " + serverHashHex);

                if (ord.getSignature() == null || ord.getPublicKey() == null || ord.getSignature().trim().isEmpty()) {
                    ord.setSignatureStatus("TAMPERED");
                    ord.setDecryptedHash("Hệ thống phát hiện đơn hàng không có chữ ký số xác thực!");
                    continue;
                }

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
            KeyFactory kf = KeyFactory.getInstance("RSA");
            PublicKey publicKey = kf.generatePublic(spec);

            Signature sig = Signature.getInstance("SHA256withRSA");
            sig.initVerify(publicKey);
            sig.update(data.getBytes(StandardCharsets.UTF_8));

            return sig.verify(Base64.getDecoder().decode(signatureBase64));
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}