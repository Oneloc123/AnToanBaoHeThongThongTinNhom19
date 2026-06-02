<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - LUXCAR Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --admin-primary: #1e81b0;
            --admin-bg: #f5f7f9;
            --admin-sidebar: #ffffff;
            --admin-text: #333333;
            --admin-border: #eaedf1;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--admin-bg);
            color: var(--admin-text);
            margin: 0;
            overflow-x: hidden;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        .sidebar {
            width: 260px;
            flex-shrink: 0;
            background-color: var(--admin-sidebar);
            border-right: 1px solid var(--admin-border);
            height: 100vh;
            position: sticky;
            top: 0;
            padding: 20px 15px;
            overflow-y: auto;
        }

        .logo {
            font-size: 1.4rem;
            font-weight: 700;
            color: #1a365d;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            padding-left: 10px;
        }

        .logo i {
            color: var(--admin-primary);
        }

        .sidebar nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar nav ul li {
            margin-bottom: 5px;
        }

        .sidebar nav ul li a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 15px;
            border-radius: 50px;
            color: #64748b;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s;
            font-size: 0.95rem;
        }

        .sidebar nav ul li a i {
            font-size: 1.2rem;
        }

        .sidebar nav ul li a:hover {
            background-color: #f8fafc;
            color: var(--admin-primary);
        }

        .sidebar nav ul li a.active {
            background-color: #eff6ff;
            color: var(--admin-primary);
        }

        .main-content {
            flex: 1;
            padding: 30px;
            max-width: calc(100% - 260px);
        }

        .content-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            padding: 25px;
            border: 1px solid var(--admin-border);
        }

        .page-header-block {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 15px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .page-title {
            font-size: 20px;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .page-title i {
            color: var(--admin-primary);
        }

        .search-input, .custom-select, .btn-pill {
            border-radius: 50px !important;
            padding: 10px 20px !important;
            box-shadow: none !important;
            border-color: #cbd5e1;
        }

        .search-input:focus, .custom-select:focus {
            border-color: var(--admin-primary);
        }

        .btn-pill {
            background-color: var(--admin-primary);
            color: white;
            border: none;
            font-weight: 500;
        }

        .btn-pill:hover {
            background-color: #15658e;
            color: white;
        }

        .table > thead > tr > th {
            text-transform: uppercase;
            font-size: 12px;
            color: #64748b;
            font-weight: 600;
            padding: 15px;
            border-bottom: 2px solid var(--admin-border);
            background-color: transparent;
            white-space: nowrap;
        }

        .table > tbody > tr > td {
            vertical-align: middle;
            font-size: 14px;
            padding: 15px;
            color: #334155;
            border-bottom: 1px solid var(--admin-border);
        }

        /* Thêm hiệu ứng highlight dòng lỗi can thiệp hệ thống */
        .row-tampered {
            background-color: #fffff0;
        }

        .col-nowrap {
            white-space: nowrap;
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 500;
            border: 1px solid transparent;
            display: inline-block;
            white-space: nowrap;
        }

        .status-pending { background: #fffbeb; color: #b45309; border-color: #fde68a; }
        .status-confirmed { background: #eff6ff; color: #1d4ed8; border-color: #bfdbfe; }
        .status-delivered { background: #f0fdf4; color: #15803d; border-color: #bbf7d0; }
        .status-cancelled { background: #fef2f2; color: #b91c1c; border-color: #fecaca; }

        /* THÊM MỚI CSS: Trạng thái đối soát chữ ký số */
        .sig-valid { background: #f0fdf4; color: #166534; border-color: #bbf7d0; }
        .sig-tampered { background: #fef2f2; color: #991b1b; border-color: #fecaca; font-weight: bold; }
        .sig-revoked { background: #fff7ed; color: #9a3412; border-color: #ffedd5; }

        .btn-action {
            border-radius: 50px;
            padding: 6px 14px;
            font-size: 12px;
            font-weight: 500;
            background: transparent;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            border: 1px solid;
            transition: 0.2s;
            white-space: nowrap;
        }

        .btn-view { border-color: #64748b; color: #64748b; }
        .btn-view:hover { background: #64748b; color: white; }
        .btn-confirm { border-color: #0ea5e9; color: #0ea5e9; }
        .btn-confirm:hover { background: #0ea5e9; color: white; }
        .btn-deliver { border-color: #22c55e; color: #22c55e; }
        .btn-deliver:hover { background: #22c55e; color: white; }
        .btn-cancel { border-color: #ef4444; color: #ef4444; }
        .btn-cancel:hover { background: #ef4444; color: white; }

        /* Nút Xem mới */
        .action-view {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
            border-radius: 50px;
            padding: 6px 14px;
            transition: 0.2s;
        }
        .action-view:hover {
            background: #64748b;
            color: white;
        }

        /* CSS CHO MODAL CHI TIẾT ĐƠN HÀNG */
        .form-card { padding: 25px; }
        .form-section {
            background: #fefefe;
            border: 1px solid #eef2f6;
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .form-section-title {
            font-size: 14px;
            font-weight: 600;
            color: #2c7da0;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* THÊM MỚI CSS: Khung mã hóa đối soát dữ liệu */
        .form-section-security {
            border-left: 4px solid #ef4444 !important;
            background: #fffafb;
        }
        .crypto-box {
            background: #1e293b;
            color: #38bdf8;
            border-radius: 10px;
            padding: 12px 15px;
            font-family: 'Courier New', Courier, monospace;
            font-size: 12.5px;
            word-break: break-all;
            margin-top: 5px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        .btn-cancel-modal {
            border: 1px solid #e2e8f0;
            padding: 8px 18px;
            border-radius: 30px;
            color: #64748b;
            text-decoration: none;
            background: transparent;
        }
        .btn-cancel-modal:hover {
            border-color: #2c7da0;
            color: #2c7da0;
        }
        .form-control:read-only {
            background-color: #f8fafc;
            color: #475569;
        }
    </style>
</head>
<body>

<div class="admin-layout">

    <%@ include file="sidebar/sidebar.jsp"%>

    <main class="main-content">
        <div class="content-card">
            <div class="page-header-block">
                <h2 class="page-title"><i class="bi bi-receipt"></i> Quản lý đơn hàng</h2>
                <button class="btn btn-pill"><i class="bi bi-download me-1"></i> Xuất dữ liệu</button>
            </div>

            <form action="order-admin" method="GET" class="row g-3 mb-4 align-items-center">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0" style="border-radius: 50px 0 0 50px; border-color: #cbd5e1; padding-left: 20px;">
                            <i class="bi bi-search text-muted"></i>
                        </span>
                        <input type="text" name="search" class="form-control search-input border-start-0 ps-0" style="border-radius: 0 50px 50px 0 !important;" placeholder="Tìm kiếm mã đơn...">
                    </div>
                </div>

                <div class="col-md-3">
                    <select name="status" class="form-select custom-select">
                        <option value="">Tất cả trạng thái đơn</option>
                        <option value="PENDING">Chờ xử lý</option>
                        <option value="CONFIRMED">Đã xác nhận</option>
                        <option value="DELIVERED">Đã giao</option>
                        <option value="CANCELLED">Đã hủy</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <select name="signatureStatus" class="form-select custom-select">
                        <option value="">Tất cả trạng thái chữ ký</option>
                        <option value="VALID">Chữ ký hợp lệ (Valid)</option>
                        <option value="TAMPERED">Dữ liệu bị can thiệp (Tampered)</option>
                        <option value="KEY_REVOKED">Khóa đã báo hủy (Key Revoked)</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <button type="submit" class="btn btn-pill w-100"><i class="bi bi-funnel me-1"></i> Lọc</button>
                </div>
            </form>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="alert alert-info text-center mt-4">Không tìm thấy đơn hàng nào.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr class="text-uppercase small">
                                <th>Mã ĐH</th>
                                <th>Mã Khách hàng</th>
                                <th>Ngày đặt</th>
                                <th style="width: 12%;">Địa chỉ</th>
                                <th>Sản phẩm</th>
                                <th>Tổng tiền</th>
                                <th>Thanh toán</th>
                                <th>Trạng thái</th>
                                <th>Xác thực chữ ký</th>
                                <th class="text-center">Hành động</th>
                            </tr>
                            </thead>
                            <tbody>

                            <c:forEach var="ord" items="${orders}">
                                <c:set var="simulatedSig" value="${ord.signatureStatus}" />

                                <tr class="${simulatedSig == 'TAMPERED' ? 'row-tampered' : ''}">
                                    <td class="fw-bold col-nowrap" style="color: #0f172a;">#ORD-${ord.id}</td>

                                    <td>
                                        <div class="fw-semibold" style="color: #334155;">${ord.userId}</div>
                                        <small class="text-muted">UID: ${ord.userId}</small>
                                    </td>

                                    <td class="col-nowrap">${ord.orderDate}</td>

                                    <td>
                                        <div class="text-truncate" style="max-width: 120px;" title="${ord.shippingAddress}">
                                                ${ord.shippingAddress}
                                        </div>
                                    </td>

                                    <td>${ord.items}</td>

                                    <td class="col-nowrap fw-bold text-danger">
                                        <fmt:formatNumber value="${ord.totalAmount}" type="number" groupingUsed="true"/> ₫
                                    </td>

                                    <td><span class="badge bg-dark">Digital Sign</span></td>

                                    <td class="col-nowrap" id="status-cell-${ord.id}">
                                        <c:choose>
                                            <c:when test="${ord.orderStatus == 'PENDING' || ord.orderStatus == 'Đang xử lý'}">
                                                <span class="status-badge status-pending">Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${ord.orderStatus == 'CONFIRMED' || ord.orderStatus == 'Đã xác nhận'}">
                                                <span class="status-badge status-confirmed">Đã xác nhận</span>
                                            </c:when>
                                            <c:when test="${ord.orderStatus == 'DELIVERED' || ord.orderStatus == 'Đã giao'}">
                                                <span class="status-badge status-delivered">Đã giao</span>
                                            </c:when>
                                            <c:when test="${ord.orderStatus == 'CANCELLED' || ord.orderStatus == 'Đã hủy'}">
                                                <span class="status-badge status-cancelled">Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-pending">${ord.orderStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="col-nowrap">
                                        <c:choose>
                                            <c:when test="${simulatedSig == 'VALID'}">
                                                <span class="status-badge sig-valid"><i class="bi bi-shield-check me-1"></i> Hợp lệ</span>
                                            </c:when>
                                            <c:when test="${simulatedSig == 'TAMPERED'}">
                                                <span class="status-badge sig-tampered"><i class="bi bi-exclamation-triangle me-1"></i> Bị can thiệp!</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge sig-revoked"><i class="bi bi-key-fill me-1"></i> Khóa đã báo hủy</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="col-nowrap">
                                        <div id="action-buttons-${ord.id}" class="d-flex justify-content-center gap-2 flex-nowrap">

                                            <button class="action-btn action-view" data-bs-toggle="modal" data-bs-target="#viewOrderModal${ord.id}">
                                                <i class="bi bi-eye"></i>
                                            </button>

                                            <c:choose>
                                                <c:when test="${simulatedSig == 'TAMPERED' || simulatedSig == 'KEY_REVOKED'}">
                                                    <button type="button" class="btn-action btn-cancel" onclick="updateStatusOrder(event, ${ord.id}, 'CANCELLED')">
                                                        <i class="bi bi-shield-slash"></i> Hủy đơn rủi ro
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${ord.orderStatus == 'PENDING' || ord.orderStatus == 'Đang xử lý'}">
                                                            <button type="button" class="btn-action btn-confirm" onclick="updateStatusOrder(event, ${ord.id}, 'CONFIRMED')">
                                                                <i class="bi bi-check2-circle"></i> Xác nhận
                                                            </button>
                                                            <button type="button" class="btn-action btn-cancel" onclick="updateStatusOrder(event, ${ord.id}, 'CANCELLED')">
                                                                <i class="bi bi-x-circle"></i> Hủy đơn
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${ord.orderStatus == 'CONFIRMED' || ord.orderStatus == 'Đã xác nhận'}">
                                                            <button type="button" class="btn-action btn-deliver" onclick="updateStatusOrder(event, ${ord.id}, 'DELIVERED')">
                                                                <i class="bi bi-truck"></i> Đã giao
                                                            </button>
                                                            <button type="button" class="btn-action btn-cancel" onclick="updateStatusOrder(event, ${ord.id}, 'CANCELLED')">
                                                                <i class="bi bi-x-circle"></i> Hủy đơn
                                                            </button>
                                                        </c:when>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <c:forEach var="ord" items="${orders}">
            <c:set var="simulatedSig" value="${ord.signatureStatus}" />
            <div class="modal fade" id="viewOrderModal${ord.id}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content">
                        <div class="form-card">

                            <div class="form-section ${simulatedSig != 'VALID' ? 'form-section-security' : ''}">
                                <h3 class="form-section-title text-dark">
                                    <i class="bi bi-shield-lock-fill text-danger"></i> Kiểm tra Chữ ký điện tử & Mã Băm (Cryptographic Audit)
                                </h3>
                                <div class="row">
                                    <div class="col-md-6 mb-2">
                                        <label class="form-label text-muted small fw-bold">Mã băm hóa đơn gốc (Server tính toán từ DB)</label>
                                        <div class="crypto-box">${ord.serverHash}</div>
                                    </div>
                                    <div class="col-md-6 mb-2">
                                        <label class="form-label text-muted small fw-bold">Mã băm trích xuất (Giải mã qua Public Key)</label>
                                        <div class="crypto-box" style="${simulatedSig == 'TAMPERED' ? 'color: #ef4444;' : ''}">
                                                ${ord.decryptedHash}
                                        </div>
                                    </div>
                            </div>

                            <div class="form-section">
                                <h3 class="form-section-title">
                                    <i class="bi bi-cart-check-fill"></i> Thông tin Đơn hàng #ORD-${ord.id}
                                </h3>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label text-muted small">Ngày đặt</label>
                                        <input type="text" class="form-control" value="${ord.orderDate}" readonly>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label text-muted small">Trạng thái</label>
                                        <input type="text" class="form-control text-primary fw-bold" value="${ord.orderStatus}" readonly>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label text-muted small">Phương thức thanh toán</label>
                                        <input type="text" class="form-control" value="Chữ ký điện tử bảo mật" readonly>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <h3 class="form-section-title">
                                    <i class="bi bi-person-lines-fill"></i> Thông tin Khách hàng & Giao hàng
                                </h3>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small">ID Người mua</label>
                                        <input type="text" class="form-control" value="${ord.userId}" readonly>
                                    </div>
                                    <div class="col-12 mb-3">
                                        <label class="form-label text-muted small">Địa chỉ giao hàng</label>
                                        <input type="text" class="form-control" value="${ord.shippingAddress}" readonly>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <h3 class="form-section-title">
                                    <i class="bi bi-box-seam"></i> Chi tiết Sản phẩm
                                </h3>
                                <div class="row">
                                    <div class="col-12 mb-3">
                                        <label class="form-label text-muted small">Tên sản phẩm</label>
                                        <c:forEach items="${ord.items}" var="i">
                                            <div class="d-flex justify-content-between align-items-center border-bottom py-2">${i.product.name}</div>
                                        </c:forEach>
                                    </div>
                                    <div class="col-12 mt-2 text-end">
                                        <h4 class="text-danger fw-bold m-0">Tổng tiền: <fmt:formatNumber value="${ord.totalAmount}" type="number" groupingUsed="true"/> ₫</h4>
                                    </div>
                                </div>
                            </div>

                            <div class="form-actions">
                                <button type="button" class="btn-cancel-modal" data-bs-dismiss="modal">
                                    <i class="bi bi-x-lg"></i> Đóng
                                </button>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </main>
</div>

<div id="customToast"
     style="visibility: hidden; min-width: 250px; background-color: #28a745; color: white; text-align: center; border-radius: 5px; padding: 16px; position: fixed; z-index: 9999; right: 30px; top: 30px; font-weight: bold; box-shadow: 0px 4px 6px rgba(0,0,0,0.1); transition: opacity 1s;">
    <i class="bi bi-check-circle-fill"></i> <span id="toastMessage"> Đơn hàng đã được xác nhận!</span>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function updateStatusOrder(event, orderId, newStatus){
        event.preventDefault()

        if(newStatus === 'CANCELLED'){
            let xacnhan = confirm("HỆ THỐNG AN NINH:\nBạn có chắc chắn muốn hủy bỏ đơn hàng này (bao gồm cả lý do lỗi chữ ký số gian lận)?");
            if(xacnhan === false){
                return;
            }
        }

        let formData = new URLSearchParams({orderId: orderId, status: newStatus});

        fetch('update-order-status' ,{method: 'POST', body: formData})
            .then(function(response) {
                return response.text();
            })
            .then(function(data){
                if(data.trim() === 'success'){

                    let toast = document.getElementById("customToast");
                    toast.style.visibility = "visible";
                    toast.style.opacity = "1";

                    let trangThai = document.getElementById("status-cell-" + orderId);
                    let actionGroup = document.getElementById("action-buttons-" + orderId);

                    if("CONFIRMED" === newStatus){
                        document.getElementById("toastMessage").innerText = "Đơn hàng #ORD-"+ orderId + " đã được duyệt thành công!";

                        actionGroup.innerHTML =
                            '<button class="action-btn action-view" data-bs-toggle="modal" data-bs-target="#viewOrderModal' + orderId + '">' +
                            '<i class="bi bi-eye"></i>' +
                            '</button>' +
                            '<button type="button" class="btn-action btn-deliver" onclick="updateStatusOrder(event, ' + orderId + ', \'DELIVERED\')">' +
                            '<i class="bi bi-truck"></i> Đã giao' +
                            '</button>' +
                            '<button type="button" class="btn-action btn-cancel" onclick="updateStatusOrder(event, ' + orderId + ', \'CANCELLED\')">' +
                            '<i class="bi bi-x-circle"></i> Cancel' +
                            '</button>';

                        trangThai.innerHTML = '<span class="status-badge status-confirmed">Đã xác nhận</span>';

                    } else if("DELIVERED" === newStatus){
                        document.getElementById("toastMessage").innerText = "Đơn hàng #ORD-"+ orderId + " đã vận chuyển hoàn tất!";

                        actionGroup.innerHTML =
                            '<button class="action-btn action-view" data-bs-toggle="modal" data-bs-target="#viewOrderModal' + orderId + '">' +
                            '<i class="bi bi-eye"></i>' +
                            '</button>';

                        trangThai.innerHTML = '<span class="status-badge status-delivered">Đã giao</span>';

                    } else {
                        document.getElementById("toastMessage").innerText = "Đã huỷ đơn hàng lỗi/gian lận: #ORD-"+ orderId + "!";

                        actionGroup.innerHTML =
                            '<button class="action-btn action-view" data-bs-toggle="modal" data-bs-target="#viewOrderModal' + orderId + '">' +
                            '<i class="bi bi-eye"></i>' +
                            '</button>';

                        trangThai.innerHTML = '<span class="status-badge status-cancelled">Đã huỷ đơn</span>';
                    }

                    setTimeout(function(){
                        toast.style.opacity = "0";
                        setTimeout(function(){
                            toast.style.visibility ="hidden";
                        }, 300);
                    }, 3000);

                } else {
                    alert("Máy chủ bảo mật từ chối cập nhật! Lý do: " + data);
                }
            })
            .catch(function(error) {
                console.log("Lỗi kết nối:", error);
            });
    }
</script>

</body>
</html>