package code.salecar.dao;

import code.salecar.config.DBConnection;
import code.salecar.model.KeyManament.DigitalKey;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class OrderSignatureDAO {


    public boolean saveSignature(int orderId, String signature, int keyId) {
        String sql = "UPDATE `order` SET signature = ?, key_id = ?, verification_status = 'Verified' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, signature);
            ps.setInt(2, keyId);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getSignature(int orderId) {
        String sql = "SELECT signature FROM `order` WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("signature");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public int getKeyId(int orderId) {
        String sql = "SELECT key_id FROM `order` WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("key_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


    public String getVerificationStatus(int orderId) {
        String sql = "SELECT verification_status FROM `order` WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String status = rs.getString("verification_status");
                return status != null ? status : "Unverified";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Unverified";
    }


    public boolean markAsTampered(int orderId) {
        String sql = "UPDATE `order` SET verification_status = 'Tampered' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean verifyAndUpdateStatus(int orderId, String expectedHashData, int keyId) {
        DigitalKeyDAO keyDAO = new DigitalKeyDAO();
        DigitalKey key = keyDAO.getKeyById(keyId);
        if (key == null) return false;

        try {
            String signature = getSignature(orderId);
            if (signature == null || signature.isEmpty()) {

                String sql = "UPDATE `order` SET verification_status = 'Unverified' WHERE id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }
                return false;
            }

            java.security.PublicKey publicKey = code.salecar.service.product.RSAService.parsePublicKey(key.getPublicKey());
            boolean isValid = code.salecar.service.product.RSAService.verify(expectedHashData, signature, publicKey);

            String newStatus = isValid ? "Verified" : "Tampered";
            String sql = "UPDATE `order` SET verification_status = ? WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newStatus);
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }

            return isValid;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
