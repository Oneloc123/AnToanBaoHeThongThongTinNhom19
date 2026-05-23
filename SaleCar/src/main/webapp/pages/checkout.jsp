<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thanh toán - LUXCAR</title>

    <%-- Include header --%>
    <%@ include file="/common/header.jsp" %>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }

        /* Main layout & Sidebar (Dùng chung) */
        .profile-wrapper { display: flex; align-items: flex-start; min-height: 100vh; }
        .sidebar-menu { width: 280px; background-color: #000000; color: #ffffff; padding: 30px 0; position: sticky; top: 0; height: 100vh; overflow-y: auto; z-index: 1000; }
        .sidebar-header { padding: 0 20px 20px; border-bottom: 1px solid #333333; text-align: center; }
        .sidebar-header h3 { color: #ffffff; font-size: 24px; font-weight: 600; margin: 0; }
        .sidebar-header p { color: #999999; font-size: 14px; margin-top: 5px; }
        .menu-items { padding: 20px 0; }
        .menu-item { display: flex; align-items: center; padding: 12px 25px; color: #ffffff; text-decoration: none; transition: all 0.3s; margin: 5px 10px; border-radius: 8px; }
        .menu-item i { width: 25px; margin-right: 12px; font-size: 18px; }
        .menu-item span { font-size: 15px; font-weight: 500; }
        .menu-item:hover { background-color: #333333; color: #ffffff; }
        .menu-item.active { background-color: #ffffff; color: #000000; }
        .menu-item.active i { color: #000000; }
        .menu-divider { height: 1px; background-color: #333333; margin: 15px 20px; }

        /* Main Content */
        .main-content { flex: 1; padding: 30px; }
        .content-header { margin-bottom: 30px; }
        .content-header h1 { font-size: 28px; font-weight: 600; color: #000000; margin-bottom: 10px; }
        .breadcrumb { background: none; padding: 0; margin: 0; list-style: none; display: flex; }
        .breadcrumb-item { margin-right: 10px; }
        .breadcrumb-item a { color: #666666; text-decoration: none; }
        .breadcrumb-item.active { color: #000000; font-weight: 500; }

        /* Checkout Layout */
        .checkout-container { display: flex; gap: 30px; align-items: flex-start; }
        .checkout-form-section { flex: 2; }
        .checkout-summary-section { flex: 1; position: sticky; top: 30px; }

        /* Form & Cards */
        .checkout-card { background: #ffffff; border-radius: 12px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); padding: 30px; margin-bottom: 25px; }
        .checkout-card h3 { font-size: 18px; font-weight: 600; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #000; display: flex; align-items: center; gap: 10px; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 14px; font-weight: 500; margin-bottom: 8px; color: #333; }
        .form-control { width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; transition: border-color 0.3s; }
        .form-control:focus { outline: none; border-color: #000; }

        /* Payment Methods */
        .payment-method { border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin-bottom: 15px; cursor: pointer; display: flex; align-items: center; gap: 15px; transition: 0.3s; }
        .payment-method:hover { border-color: #000; }
        .payment-method input[type="radio"] { width: 18px; height: 18px; accent-color: #000; }
        .payment-icon { font-size: 24px; color: #000; width: 40px; text-align: center; }
        .payment-details h4 { font-size: 15px; font-weight: 600; margin-bottom: 5px; color: #000; }
        .payment-details p { font-size: 13px; color: #666; margin: 0; }

        /* Order Summary */
        .summary-item { display: flex; justify-content: space-between; align-items: center; padding-bottom: 15px; margin-bottom: 15px; border-bottom: 1px dashed #eee; }
        .summary-item-info { display: flex; align-items: center; gap: 15px; }
        .summary-img { width: 60px; height: 45px; background: #f0f0f0; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: #999; }
        .summary-name { font-size: 14px; font-weight: 600; color: #000; }
        .summary-qty { font-size: 12px; color: #666; }
        .summary-price { font-size: 14px; font-weight: 600; color: #000; }

        .summary-calc { margin-top: 20px; }
        .calc-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 14px; color: #666; }
        .calc-row.total { border-top: 2px solid #000; padding-top: 15px; font-size: 18px; font-weight: 700; color: #d9534f; margin-bottom: 25px; }

        .btn-submit-order { width: 100%; background-color: #000; color: #fff; padding: 15px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: 0.3s; display: flex; align-items: center; justify-content: center; gap: 10px; }
        .btn-submit-order:hover { background-color: #333; }

        /* Responsive */
        @media (max-width: 992px) {
            .checkout-container { flex-direction: column; }
            .checkout-summary-section { position: static; width: 100%; }
        }

        /* edit address */
        .address-slot {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
            display: block;
            background: #fff;
        }
        .address-slot:hover {
            border-color: #000;
            box-shadow: 0 4px 10px rgba(0,0,0,0.04);
        }
        .address-slot.selected {
            border-color: #000;
            background-color: #fafafa;
        }
        /* SỬA LỖI: Chuyển từ icon Bootstrap sang FontAwesome check-circle */
        .address-slot.selected::after {
            content: '\f058';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            top: 15px;
            right: 15px;
            color: #000;
            font-size: 1.2rem;
        }
        .address-radio-hidden {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }
        .address-name { font-weight: 600; color: #000; margin-bottom: 5px; font-size: 15px; }
        .address-phone { font-size: 13px; color: #555; margin-bottom: 5px; }
        .address-detail { font-size: 13px; color: #666; margin-bottom: 0; line-height: 1.4; }
        .badge-default {
            background: #000; color: #fff; font-size: 10px;
            padding: 3px 8px; border-radius: 12px; margin-left: 8px; vertical-align: middle;
        }

        /* Nút thêm địa chỉ dashed */
        .btn-add-address {
            border: 2px dashed #ccc;
            background: transparent;
            color: #666;
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            font-weight: 600;
            transition: 0.2s;
            text-align: center;
            cursor: pointer;
        }
        .btn-add-address:hover {
            border-color: #000;
            color: #000;
            background: #fafafa;
        }
    </style>
</head>
<body>
<div class="profile-wrapper">
    <div class="sidebar-menu">
        <div class="menu-items">
            <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                <i class="fas fa-chart-pie"></i>
                <span>Bảng điều khiển</span>
            </a>
            <a href="${pageContext.request.contextPath}/profile" class="menu-item ">
                <i class="fas fa-user-circle"></i>
                <span>Thông tin cá nhân</span>
            </a>
            <a href="${pageContext.request.contextPath}/profileEdit" class="menu-item">
                <i class="fas fa-user-edit"></i>
                <span>Chỉnh sửa thông tin</span>
            </a>
            <a href="${pageContext.request.contextPath}/changePassword" class="menu-item">
                <i class="fas fa-lock"></i>
                <span>Đổi mật khẩu</span>
            </a>
            <a href="${pageContext.request.contextPath}/order" class="menu-item">
                <i class="fas fa-shopping-bag"></i>
                <span>Đơn hàng của tôi</span>
            </a>
            <a href="${pageContext.request.contextPath}/cart" class="menu-item active">
                <i class="fas fa-shopping-cart"></i><span>Giỏ hàng</span>
            </a>
            <a href="${pageContext.request.contextPath}/favorites" class="menu-item">
                <i class="fas fa-heart"></i>
                <span>Sản phẩm yêu thích</span>
            </a>
            <div class="menu-divider"></div>
            <a href="${pageContext.request.contextPath}/logout" class="menu-item">
                <i class="fas fa-sign-out-alt"></i>
                <span>Đăng xuất</span>
            </a>
        </div>
    </div>

    <div class="main-content">
        <div class="content-header">
            <h1>Thanh toán</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a> <i class="fas fa-chevron-right" style="font-size: 10px; margin: 0 5px;"></i></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a> <i class="fas fa-chevron-right" style="font-size: 10px; margin: 0 5px;"></i></li>
                    <li class="breadcrumb-item active">Thanh toán</li>
                </ol>
            </nav>
        </div>

        <form action="process-checkout" id="checkoutForm" method="POST">
            <input type="hidden" name="type" value="${param.type}">

            <input type="hidden" id="digitalSignature" name="digitalSignature" value="">

            <div class="checkout-container">
                <div class="checkout-form-section">
                    <div class="checkout-card">
                        <h3><i class="fas fa-map-marker-alt"></i> Thông tin giao hàng (Shipping Address)</h3>

                        <div class="form-group">
                            <label for="fullName">Họ và tên người nhận</label>
                            <input type="text" id="fullName" name="fullName" class="form-control" value="${sessionScope.user != null ? sessionScope.user.username : ''}" placeholder="Nhập họ tên..." required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại (Phone)</label>
                            <input type="text" id="phone" name="phone" class="form-control" value="${sessionScope.user != null ? sessionScope.user.phonenumber : ''}" placeholder="Nhập số điện thoại..." required>
                        </div>

                        <div class="form-group mb-4">
                            <label class="mb-3">Địa chỉ nhận hàng (Shipping Address) <span class="text-danger">*</span></label>
                            <div id="address-slots-container">
                                <c:choose>
                                    <c:when test="${empty listAddress}">
                                        <div class="alert alert-warning py-2 mb-3" style="font-size: 14px; border-radius: 8px;">
                                            <i class="fas fa-exclamation-triangle"></i> Bạn chưa có địa chỉ nào, hãy thêm mới để đặt hàng!
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="addr" items="${listAddress}" varStatus="status">
                                            <c:set var="radioId" value="addr_${addr.id}" />
                                            <input type="radio" class="address-radio-hidden" id="${radioId}" name="shippingAddress" value="${addr.street}, ${addr.commune}, ${addr.province}" ${status.first ? 'checked' : ''}>
                                            <label for="${radioId}" class="address-slot ${status.first ? 'selected' : ''}">
                                                <div class="address-name">
                                                    <i class="fas fa-user-tag text-muted me-1"></i> ${addr.name}
                                                    <c:if test="${addr.type == 'main'}"><span class="badge-default">Mặc định</span></c:if>
                                                </div>
                                                <div class="address-detail"><i class="fas fa-map-marker-alt text-muted me-2"></i> ${addr.street}, ${addr.commune}, ${addr.province}</div>
                                            </label>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <button type="button" class="btn-add-address mt-2" data-bs-toggle="modal" data-bs-target="#addAddressModal">
                                <i class="fas fa-plus-circle me-1"></i> Thêm địa chỉ mới
                            </button>
                        </div>
                    </div>

                    <div class="checkout-card">
                        <h3><i class="fas fa-wallet"></i> Phương thức thanh toán & Xác thực</h3>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="COD" checked>
                            <div class="payment-icon"><i class="fas fa-money-bill-wave"></i></div>
                            <div class="payment-details">
                                <h4>Thanh toán khi nhận hàng (COD)</h4>
                                <p>Thanh toán bằng tiền mặt khi giao hàng tận nơi.</p>
                            </div>
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="VNPAY">
                            <div class="payment-icon"><i class="fas fa-qrcode" style="color: #005baa;"></i></div>
                            <div class="payment-details">
                                <h4>Thanh toán qua VNPAY</h4>
                                <p>Thanh toán an toàn qua ví điện tử VNPay hoặc quét mã QR ngân hàng.</p>
                            </div>
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="DIGITAL_SIGNATURE">
                            <div class="payment-icon"><i class="fas fa-key" style="color: #ff9900;"></i></div>
                            <div class="payment-details">
                                <h4>Xác thực bằng Chữ ký điện tử (RSA/DSA)</h4>
                                <p>Sử dụng Khóa bí mật (Private Key) để băm dữ liệu đơn hàng và ký xác thực bảo mật tuyệt đối.</p>
                            </div>
                        </label>
                    </div>
                </div>

                <div class="checkout-summary-section">
                    <div class="checkout-card">
                        <h3><i class="fas fa-receipt"></i> Tóm tắt đơn hàng</h3>

                        <div class="mb-3">
                            <label class="form-label">Chọn Voucher</label>
                            <select id="voucherSelect" name="voucherId" class="form-select">
                                <c:forEach items="${vouchers}" var="v">
                                    <option value="${v.id}">
                                            ${v.code} - Giảm ${v.value}${v.valueType == 'PERCENT' ? '%' : ' ₫'}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="summary-items-list">
                            <c:forEach var="item" items="${checkoutCart.items}">
                                <div class="summary-item">
                                    <div class="summary-item-info">
                                        <img src="${not empty item.productDetail.images ? item.productDetail.images[0] : 'https://placehold.co/50'}" style="width: 50px; height: 50px; object-fit: cover;" alt="${item.productDetail.productName}" />
                                        <div>
                                            <div class="summary-name">${item.productDetail.productName}</div>
                                            <div class="summary-qty">Số lượng: ${item.quantity}</div>
                                        </div>
                                    </div>
                                    <div class="summary-price">
                                        <fmt:formatNumber value="${item.totalPrice}" type="number" groupingUsed="true"/> ₫
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="summary-calc">
                            <div class="calc-row">
                                <span>Tạm tính:</span>
                                <span><fmt:formatNumber value="${checkoutCart.total}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                            <div class="calc-row">
                                <span>Phí vận chuyển:</span>
                                <span>Miễn phí</span>
                            </div>
                            <div class="calc-row total">
                                <span>Tổng cộng (Total Amount):</span>
                                <span id="totalPrice"><fmt:formatNumber value="${checkoutCart.total}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${empty listAddress}">
                                <button type="button" class="btn-submit-order" style="background-color: #6c757d; cursor: not-allowed;" disabled>
                                    <i class="fas fa-lock"></i> Vui lòng thêm địa chỉ để Đặt hàng
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="submit" class="btn-submit-order">
                                    <i class="fas fa-check-circle"></i> Đặt Hàng
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<%-- Modal dia chi --%>
<div class="modal fade" id="addAddressModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 12px; border: none;">
            <div class="modal-header" style="border-bottom: 1px solid #eee;">
                <h5 class="modal-title fw-bold" style="color: #000;">
                    <i class="fas fa-map-marked-alt me-2"></i> Thêm địa chỉ giao hàng
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" style="padding: 25px;">
                <form id="newAddressForm">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Tên người nhận</label>
                        <input type="text" class="form-control" id="newAddrName" name="newName" placeholder="Nhập họ tên..." required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Tỉnh / Thành phố <span class="text-danger">*</span></label>
                        <select class="form-select" id="newAddrProvince" required>
                            <option value="" selected disabled>Chọn Tỉnh / Thành phố</option>
                        </select>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label fw-bold small">Quận / Huyện <span class="text-danger">*</span></label>
                            <select class="form-select" id="newAddrDistrict" required disabled>
                                <option value="" selected disabled>Chọn Quận / Huyện</option>
                            </select>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label fw-bold small">Phường / Xã <span class="text-danger">*</span></label>
                            <select class="form-select" id="newAddrWard" required disabled>
                                <option value="" selected disabled>Chọn Phường / Xã</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Số nhà, Tên đường <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="newAddrStreet" name="newStreet" placeholder="VD: Số 120 Yên Lãng" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer" style="border-top: none;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="border-radius: 8px;">Hủy bỏ</button>
                <button type="button" class="btn btn-dark" id="btnSaveAddress" style="border-radius: 8px;">
                    <i class="fas fa-save me-1"></i> Lưu địa chỉ
                </button>
            </div>
        </div>
    </div>
</div>

</body>
<script>
    // XỬ LÝ LOGIC CHỮ KÝ SỐ KHI SUBMIT FORM
    document.getElementById("checkoutForm").addEventListener("submit", function(e) {
        // Kiểm tra phương thức người dùng lựa chọn
        const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

        if (selectedMethod === "DIGITAL_SIGNATURE") {
            const currentSignature = document.getElementById("digitalSignature").value;

            // Nếu chưa có chữ ký trong hidden input, chặn lại để thực hiện quy trình ký
            if (!currentSignature) {
                e.preventDefault(); // Chặn việc gửi form ngay lập tức

                // Mở Prompt/Popup yêu cầu mã PIN thiết bị chứa Private Key (USB Token, SmartCard, CloudCA...)
                let pin = prompt("HỆ THỐNG KÝ SỐ ĐIỆN TỬ (RSA/DSA):\nNhập mã PIN Chứng thư số của bạn để ký xác nhận đơn hàng:");

                if (pin && pin.trim() !== "") {
                    // Logic Mô phỏng: Lấy dữ liệu đơn hàng -> Băm bằng SHA-256 -> Mã hóa bằng Private Key
                    alert("Hệ thống đang tiến hành băm dữ liệu hóa đơn (SHA-256) và mã hóa bất đối xứng...");

                    // Chuỗi giả lập Base64 đại diện cho chữ ký số được sinh ra từ Private Key của user
                    const generatedSignature = "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC3V_DUMMY_SIGNATURE_DATA_RSA_DSA_ALGORITHM_SUCCESS";

                    // Đẩy chuỗi chữ ký số vào hidden input
                    document.getElementById("digitalSignature").value = generatedSignature;

                    alert("Ký số đơn hàng thành công! Trình duyệt đang chuyển dữ liệu kèm chữ ký lên máy chủ xử lý.");

                    // Tiến hành submit form thật lên Controller/Servlet
                    this.submit();
                } else {
                    alert("Giao dịch ký số bị hủy bỏ. Vui lòng thử lại hoặc chọn phương thức thanh toán khác.");
                }
            }
        }
    });

    // Áp dụng voucher
    document.getElementById("voucherSelect").addEventListener("change", function() {
        let voucherId = this.value;
        const urlParams = new URLSearchParams(window.location.search);
        const type = urlParams.get('type') || '';

        fetch("${pageContext.request.contextPath}/voucher", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "voucherId=" + voucherId + "&type=" + type
        })
            .then(response => response.text())
            .then(data => {
                let formatted = Number(data).toLocaleString('vi-VN');
                document.getElementById("totalPrice").innerHTML = formatted + " ₫";
            })
            .catch(error => console.error("Error:", error));
    });

    // Lưu địa chỉ mới
    document.getElementById("btnSaveAddress").addEventListener("click", function(){
        const name = document.getElementById('newAddrName').value.trim();
        const province = document.getElementById('newAddrProvince').value;
        const district = document.getElementById('newAddrDistrict').value;
        const ward = document.getElementById('newAddrWard').value;
        const street = document.getElementById('newAddrStreet').value.trim();

        if(!name || !province || !district || !ward || !street){
            alert("Vui lòng điền đủ thông tin!");
            return;
        }

        const fullCommune = ward + ", " + district;
        const formData = new URLSearchParams();
        formData.append("name", name);
        formData.append("province", province);
        formData.append("commune", fullCommune);
        formData.append("street", street);
        formData.append("type", "sub");

        const btnSave = document.getElementById('btnSaveAddress');
        btnSave.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Đang lưu...';
        btnSave.disabled = true;

        fetch('${pageContext.request.contextPath}/add-address', {
            method: 'POST',
            headers: { 'Content-type' : 'application/x-www-form-urlencoded' },
            body:  formData.toString()
        })
            .then(response => response.text())
            .then(data => {
                if(data === 'success') {
                    window.location.reload();
                } else if(data === 'full_slot') {
                    alert("Bạn chỉ lưu tối đa được 6 địa chỉ, vui lòng xóa bớt!");
                    btnSave.innerHTML = '<i class="fas fa-save me-1"></i> Lưu địa chỉ';
                    btnSave.disabled = false;
                } else {
                    alert("Có lỗi xảy ra, không thể lưu địa chỉ!");
                    btnSave.innerHTML = '<i class="fas fa-save me-1"></i> Lưu địa chỉ';
                    btnSave.disabled = false;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("Lỗi kết nối máy chủ");
                btnSave.disabled = false;
            });
    });

    // API lấy dữ liệu Tỉnh thành Việt Nam
    let addressData = [];
    fetch('https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json')
        .then(response => response.json())
        .then(data => {
            addressData = data;
            const provinceSelect = document.getElementById('newAddrProvince');
            data.forEach(province => {
                let option = document.createElement('option');
                option.value = province.Name;
                option.text = province.Name;
                option.dataset.id = province.Id;
                provinceSelect.add(option);
            });
        });

    document.getElementById('newAddrProvince').addEventListener('change', function() {
        const districtSelect = document.getElementById('newAddrDistrict');
        const wardSelect = document.getElementById('newAddrWard');

        districtSelect.innerHTML = '<option value="" selected disabled>Chọn Quận / Huyện</option>';
        wardSelect.innerHTML = '<option value="" selected disabled>Chọn Phường / Xã</option>';
        districtSelect.disabled = false;
        wardSelect.disabled = true;

        const selectedOption = this.options[this.selectedIndex];
        const province = addressData.find(p => p.Id === selectedOption.dataset.id);

        if (province && province.Districts) {
            province.Districts.forEach(district => {
                let option = document.createElement('option');
                option.value = district.Name;
                option.text = district.Name;
                option.dataset.id = district.Id;
                districtSelect.add(option);
            });
        }
    });

    document.getElementById('newAddrDistrict').addEventListener('change', function() {
        const wardSelect = document.getElementById('newAddrWard');
        wardSelect.innerHTML = '<option value="" selected disabled>Chọn Phường / Xã</option>';
        wardSelect.disabled = false;

        const provinceSelect = document.getElementById('newAddrProvince');
        const selectedProvOption = provinceSelect.options[provinceSelect.selectedIndex];
        const province = addressData.find(p => p.Id === selectedProvOption.dataset.id);

        const districtId = this.options[this.selectedIndex].dataset.id;
        const district = province.Districts.find(d => d.Id === districtId);

        if (district && district.Wards) {
            district.Wards.forEach(ward => {
                let option = document.createElement('option');
                option.value = ward.Name;
                option.text = ward.Name;
                wardSelect.add(option);
            });
        }
    });

    // Xử lý UI lựa chọn địa chỉ giao hàng
    const addressRadios = document.querySelectorAll('input[name="shippingAddress"]');
    addressRadios.forEach(function(radio) {
        radio.addEventListener('change', function() {
            document.querySelectorAll('.address-slot').forEach(function(slot) {
                slot.classList.remove('selected');
            });
            if(this.checked) {
                const targetLabel = document.querySelector('label[for="' + this.id + '"]');
                if (targetLabel) {
                    targetLabel.classList.add('selected');
                }
            }
        });
    });
</script>
</html>