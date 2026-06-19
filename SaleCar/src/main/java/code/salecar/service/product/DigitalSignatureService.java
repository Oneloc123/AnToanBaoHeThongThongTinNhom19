package code.salecar.service.product;

import code.salecar.dao.DigitalKeyDAO;
import code.salecar.dao.OrderDAO;
import code.salecar.dao.OrderSignatureDAO;
import code.salecar.model.KeyManament.DigitalKey;
import code.salecar.model.Order;
import code.salecar.model.OrderItem;

import java.util.List;


public class DigitalSignatureService {

    private final DigitalKeyDAO keyDAO = new DigitalKeyDAO();
    private final OrderSignatureDAO sigDAO = new OrderSignatureDAO();
    private final OrderDAO orderDAO = new OrderDAO();


    public String generateOrderHashData(Order order) {
        if (order == null) return null;

        StringBuilder sb = new StringBuilder();
        sb.append(order.getId()).append("|");
        sb.append(order.getUserId()).append("|");
        sb.append(order.getOrderDate() != null ? order.getOrderDate().getTime() : 0).append("|");

        long totalAmount = Math.round(order.getTotalAmount() * 100);
        sb.append(totalAmount).append("|");

        List<OrderItem> items = order.getItems();
        if (items == null || items.isEmpty()) {
            items = orderDAO.getOrderItemsByOrderId(order.getId());
            order.setItems(items);
        }

        boolean first = true;
        for (OrderItem item : items) {
            if (!first) {
                sb.append("|");
            }
            sb.append(item.getProductId()).append("_");
            sb.append(item.getQuantity()).append("_");

            long unitPrice = Math.round(item.getPrice() * 100);
            sb.append(unitPrice);
            first = false;
        }

        return sb.toString();
    }


    public boolean saveSignature(int orderId, String signature, int keyId) {
        return sigDAO.saveSignature(orderId, signature, keyId);
    }


    public boolean verifyAndSign(int orderId, String signature, int userId) {
        DigitalKey activeKey = keyDAO.getActiveKeyByUserId(userId);
        if (activeKey == null) return false;

        Order order = orderDAO.getOrderById(orderId);
        if (order == null || order.getUserId() != userId) return false;

        String hashData = generateOrderHashData(order);

        try {
            java.security.PublicKey publicKey = code.salecar.service.product.DSAService.parsePublicKey(activeKey.getPublicKey());
            boolean isValid = code.salecar.service.product.DSAService.verify(hashData, signature, publicKey);

            if (isValid) {
                return sigDAO.saveSignature(orderId, signature, activeKey.getId());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean pasteAndVerify(int orderId, String signature, int userId) {
        int keyId = sigDAO.getKeyId(orderId);
        DigitalKey key;

        if (keyId > 0) {
            key = keyDAO.getKeyById(keyId);
        } else {
            key = keyDAO.getActiveKeyByUserId(userId);
        }
        if (key == null) return false;

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) return false;

        String hashData = generateOrderHashData(order);

        try {
            java.security.PublicKey publicKey = code.salecar.service.product.DSAService.parsePublicKey(key.getPublicKey());
            boolean isValid = code.salecar.service.product.DSAService.verify(hashData, signature, publicKey);

            if (isValid) {
                return sigDAO.saveSignature(orderId, signature, key.getId());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<TamperAlert> checkTamperedOrders(int userId) {
        java.util.List<TamperAlert> alerts = new java.util.ArrayList<>();
        List<Order> orders = orderDAO.getOrdersByUserId(userId);

        for (Order order : orders) {
            String signature = sigDAO.getSignature(order.getId());
            if (signature == null || signature.isEmpty()) {
                if (!"Unverified".equals(sigDAO.getVerificationStatus(order.getId()))) {
                    String sql = "UPDATE `order` SET verification_status = 'Unverified' WHERE id = ?";
                    try (java.sql.Connection conn = code.salecar.config.DBConnection.getConnection();
                         java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, order.getId());
                        ps.executeUpdate();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                continue;
            }

            int keyId = sigDAO.getKeyId(order.getId());
            if (keyId <= 0) continue;

            DigitalKey key = keyDAO.getKeyById(keyId);
            if (key == null) continue;

            try {
                String hashData = generateOrderHashData(order);
                java.security.PublicKey publicKey = code.salecar.service.product.DSAService.parsePublicKey(key.getPublicKey());
                boolean isValid = code.salecar.service.product.DSAService.verify(hashData, signature, publicKey);

                if (!isValid) {
                    sigDAO.markAsTampered(order.getId());
                    alerts.add(new TamperAlert(order.getId(), order.getOrderDate()));
                } else {

                    String currentVer = sigDAO.getVerificationStatus(order.getId());
                    if (!"Verified".equals(currentVer)) {
                        String sql = "UPDATE `order` SET verification_status = 'Verified' WHERE id = ?";
                        try (java.sql.Connection conn = code.salecar.config.DBConnection.getConnection();
                             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, order.getId());
                            ps.executeUpdate();
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return alerts;
    }

    public java.util.List<TamperAlert> checkAllTamperedOrders() {
        java.util.List<TamperAlert> alerts = new java.util.ArrayList<>();
        List<Order> orders = orderDAO.getAllOrders();

        for (Order order : orders) {
            String signature = sigDAO.getSignature(order.getId());
            if (signature == null || signature.isEmpty()) continue;

            int keyId = sigDAO.getKeyId(order.getId());
            if (keyId <= 0) continue;

            DigitalKey key = keyDAO.getKeyById(keyId);
            if (key == null) continue;

            try {
                String hashData = generateOrderHashData(order);
                java.security.PublicKey publicKey = code.salecar.service.product.DSAService.parsePublicKey(key.getPublicKey());
                boolean isValid = code.salecar.service.product.DSAService.verify(hashData, signature, publicKey);

                if (!isValid) {
                    sigDAO.markAsTampered(order.getId());
                    alerts.add(new TamperAlert(order.getId(), order.getOrderDate()));
                } else {
                    String currentVer = sigDAO.getVerificationStatus(order.getId());
                    if (!"Verified".equals(currentVer)) {
                        String sql = "UPDATE `order` SET verification_status = 'Verified' WHERE id = ?";
                        try (java.sql.Connection conn = code.salecar.config.DBConnection.getConnection();
                             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, order.getId());
                            ps.executeUpdate();
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return alerts;
    }

    public String getVerificationStatus(int orderId) {
        return sigDAO.getVerificationStatus(orderId);
    }

    public int getKeyId(int orderId) {
        return sigDAO.getKeyId(orderId);
    }

    public static class TamperAlert {
        private final int orderId;
        private final java.util.Date orderDate;

        public TamperAlert(int orderId, java.util.Date orderDate) {
            this.orderId = orderId;
            this.orderDate = orderDate;
        }

        public int getOrderId() {
            return orderId;
        }

        public java.util.Date getOrderDate() {
            return orderDate;
        }
    }
}
