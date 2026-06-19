package code.salecar.dao;

import code.salecar.config.DBConnection;
import code.salecar.model.KeyManament.DigitalKey;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DigitalKeyDAO {

    public int insertKey(DigitalKey key) {
        String sql = "INSERT INTO digital_keys (user_id, public_key, status, created_at) VALUES (?, ?, 'ACTIVE', NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, key.getUserId());
            ps.setString(2, key.getPublicKey());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public DigitalKey getActiveKeyByUserId(int userId) {
        String sql = "SELECT * FROM digital_keys WHERE user_id = ? AND status = 'ACTIVE' ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public DigitalKey getKeyById(int keyId) {
        String sql = "SELECT * FROM digital_keys WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, keyId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<DigitalKey> getKeysByUserId(int userId) {
        List<DigitalKey> list = new ArrayList<>();
        String sql = "SELECT * FROM digital_keys WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean revokeActiveKey(int userId) {
        String sql = "UPDATE digital_keys SET status = 'REVOKED', revoked_at = NOW() WHERE user_id = ? AND status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasActiveKey(int userId) {
        String sql = "SELECT COUNT(*) FROM digital_keys WHERE user_id = ? AND status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasAnyKey(int userId) {
        String sql = "SELECT COUNT(*) FROM digital_keys WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private DigitalKey mapRow(ResultSet rs) throws SQLException {
        DigitalKey key = new DigitalKey();
        key.setId(rs.getInt("id"));
        key.setUserId(rs.getInt("user_id"));
        key.setPublicKey(rs.getString("public_key"));
        key.setStatus(rs.getString("status"));
        key.setCreatedAt(rs.getTimestamp("created_at"));
        key.setRevokedAt(rs.getTimestamp("revoked_at"));
        return key;
    }
}
