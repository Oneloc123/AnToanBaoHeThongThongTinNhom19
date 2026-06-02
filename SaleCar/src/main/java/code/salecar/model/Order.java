package code.salecar.model;

import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private int userId;


    private Date orderDate;
    private double totalAmount;
    private String shippingAddress;
    private String phone;
    private String paymentMethod;
    private String orderStatus;
    private List<OrderItem> items;

    // them cac truong moi de xu li chu ki
    private String signature;
    private String publicKey;
    private String signatureStatus;
    private String serverHash;
    private String decryptedHash;

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

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

    public String getSignatureStatus() {
        return signatureStatus;
    }

    public void setSignatureStatus(String signatureStatus) {
        this.signatureStatus = signatureStatus;
    }

    public String getServerHash() {
        return serverHash;
    }

    public void setServerHash(String serverHash) {
        this.serverHash = serverHash;
    }

    public String getDecryptedHash() {
        return decryptedHash;
    }

    public void setDecryptedHash(String decryptedHash) {
        this.decryptedHash = decryptedHash;
    }
}