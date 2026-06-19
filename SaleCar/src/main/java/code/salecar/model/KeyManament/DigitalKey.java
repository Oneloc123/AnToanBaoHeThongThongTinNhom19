package code.salecar.model.KeyManament;

import java.util.Date;

public class DigitalKey {
    private int id;
    private int userId;
    private String publicKey;
    private String status; // ACTIVE, REVOKED
    private Date createdAt;
    private Date revokedAt;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getRevokedAt() {
        return revokedAt;
    }

    public void setRevokedAt(Date revokedAt) {
        this.revokedAt = revokedAt;
    }

    public String getMaskedPublicKey() {
        if (publicKey == null || publicKey.isEmpty()) {
            return "N/A";
        }
        String cleaned = publicKey
                .replace("<<BeginPublicKey>>", "")
                .replace("<<EndPublicKey>>", "")
                .replaceAll("\\s", "");
        if (cleaned.length() <= 70) {
            return cleaned;
        }
        return cleaned.substring(0, 30) + "..." + cleaned.substring(cleaned.length() - 20);
    }
}
