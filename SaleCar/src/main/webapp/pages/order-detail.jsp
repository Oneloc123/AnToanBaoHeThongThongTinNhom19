<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết đơn hàng - LUXCAR</title>

    <%@ include file="/common/header.jsp" %>

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/common/dark-theme.css">
    <style>
        /* ================= DIGITAL SIGNATURE ================= */
        .sig-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .sig-verified { background: rgba(46,204,113,0.12); color: #2ecc71; border: 1px solid rgba(46,204,113,0.2); }
        .sig-unverified { background: rgba(255,193,7,0.12); color: #ffc107; border: 1px solid rgba(255,193,7,0.2); }
        .sig-tampered { background: rgba(231,76,60,0.12); color: #e74c3c; border: 1px solid rgba(231,76,60,0.2); }

        .hash-data-box {
            background: var(--bg-elevated);
            border: 1.5px solid var(--border-subtle);
            border-radius: var(--radius-sm);
            padding: 12px;
            font-family: 'Courier New', monospace;
            font-size: 11px;
            color: var(--text-secondary);
            word-break: break-all;
            line-height: 1.5;
            max-height: 100px;
            overflow-y: auto;
            margin: 8px 0;
        }

        /* ================= STATUS BADGE ================= */
        .status-badge {
            padding: 7px 16px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .status-pending  { background: rgba(255,193,7,0.12); color: #ffc107; border: 1px solid rgba(255,193,7,0.2); }
        .status-shipping { background: rgba(52,152,219,0.12); color: #3498db; border: 1px solid rgba(52,152,219,0.2); }
        .status-completed{ background: rgba(46,204,113,0.12); color: #2ecc71; border: 1px solid rgba(46,204,113,0.2); }
        .status-cancelled{ background: rgba(231,76,60,0.12); color: #e74c3c; border: 1px solid rgba(231,76,60,0.2); }

        /* ================= INFO CARDS ================= */
        .order-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 18px;
            margin-bottom: 22px;
        }
        .info-card {
            background: var(--bg-surface);
            border-radius: var(--radius-lg);
            padding: 22px 24px;
            border: 1px solid var(--border-subtle);
            box-shadow: var(--shadow-card);
            transition: all var(--transition-base);
        }
        .info-card:hover {
            border-color: var(--border-gold);
            transform: translateY(-2px);
            box-shadow: var(--shadow-card-hover);
        }
        .info-card h4 {
            font-size: 11px;
            font-weight: 700;
            color: var(--gold);
            margin-bottom: 16px;
            padding-bottom: 10px;
            border-bottom: 2px solid rgba(212,175,55,0.2);
            display: flex;
            align-items: center;
            gap: 8px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        .info-row {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 11px;
            font-size: 14px;
            color: var(--text-secondary);
        }
        .info-row i { color: var(--gold); margin-top: 2px; width: 15px; flex-shrink: 0; }
        .info-row span { line-height: 1.55; flex: 1; }
        .info-row strong { color: var(--text-primary); font-weight: 600; }

        /* ================= TABLE CARD ================= */
        .order-card {
            background: var(--bg-surface);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-subtle);
            overflow: hidden;
            margin-bottom: 22px;
            box-shadow: var(--shadow-card);
            transition: all var(--transition-base);
        }
        .order-card:hover { border-color: var(--border-gold); box-shadow: var(--shadow-card-hover); }

        .lux-table { width: 100%; border-collapse: collapse; }
        .lux-table thead tr { background: #0a0a0a; }
        .lux-table th {
            padding: 15px 20px;
            text-align: left;
            font-size: 11px;
            font-weight: 700;
            color: var(--text-primary);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            border-bottom: 1px solid var(--border-subtle);
        }
        .lux-table td {
            padding: 18px 20px;
            border-bottom: 1px solid var(--border-subtle);
            vertical-align: middle;
            font-size: 14px;
            color: var(--text-secondary);
            background: var(--bg-surface);
        }
        .lux-table tbody tr:last-child td { border-bottom: none; }
        .lux-table tbody tr:hover td { background: var(--bg-elevated); }

        .product-img {
            width: 56px; height: 56px;
            background: var(--bg-elevated);
            border-radius: var(--radius-sm);
            overflow: hidden; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center;
            border: 1px solid var(--border-subtle);
        }
        .product-img img { width:100%; height:100%; object-fit:cover; }
        .product-name { font-weight: 700; color: var(--text-primary); font-size: 14px; margin-bottom: 4px; }
        .product-meta { font-size: 12px; color: var(--text-muted); }
        .price-cell { color: var(--text-secondary); }
        .total-cell { font-weight: 700; color: var(--gold); font-size: 14px; }

        .product-link {
            text-decoration: none;
            color: inherit;
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .product-link:hover .product-name { color: var(--gold); }

        /* ================= SUMMARY ================= */
        .order-summary {
            padding: 22px 24px 26px;
            background: var(--bg-elevated);
            border-top: 1px solid var(--border-subtle);
            display: flex;
            justify-content: flex-end;
        }
        .summary-inner { width: 320px; }
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            font-size: 14px;
            color: var(--text-muted);
            padding: 3px 0;
        }
        .summary-row.total {
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px dashed var(--border-gold);
            font-size: 16px;
            color: var(--text-primary);
            font-weight: 700;
        }
        .summary-row.total .total-val {
            font-size: 22px;
            font-weight: 700;
            color: var(--gold);
            font-family: 'Playfair Display', serif;
        }

        /* ================= BACK BUTTON ================= */
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 24px;
            background: transparent;
            border: 1.5px solid var(--border-gold);
            color: var(--gold);
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
            transition: all var(--transition-base);
        }
        .btn-back:hover {
            background: linear-gradient(135deg, var(--gold), var(--gold-dark));
            color: #101010;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(212,175,55,0.2);
        }

        /* ================= OVERRIDES ================= */
        .main-content { flex: 1; padding: 30px 40px; background: var(--bg-primary); min-height: 100vh; }
        .content-header h1 { font-family: 'Playfair Display', serif; }
        .btn-success {
            background: rgba(34,197,94,0.12) !important;
            border: 1px solid rgba(34,197,94,0.2) !important;
            color: #22c55e !important;
            border-radius: 20px !important;
            padding: 8px 20px !important;
            font-weight: 600 !important;
        }
        .btn-success:hover {
            background: rgba(34,197,94,0.2) !important;
            color: #22c55e !important;
        }
        .breadcrumb-item i { color: var(--text-muted); font-size: 9px; }

        /* ================= REVIEW ================= */
        .review-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        .review-badge.done {
            background: rgba(46,204,113,0.12);
            color: #2ecc71;
            border: 1px solid rgba(46,204,113,0.2);
        }
        .review-badge.pending {
            background: rgba(212,175,55,0.12);
            color: var(--gold);
            border: 1px solid rgba(212,175,55,0.2);
            cursor: pointer;
            transition: all var(--transition-base);
        }
        .review-badge.pending:hover {
            background: rgba(212,175,55,0.2);
            transform: translateY(-1px);
        }
        .review-badge.na {
            background: rgba(255,255,255,0.04);
            color: var(--text-muted);
            border: 1px solid var(--border-subtle);
        }

        /* Inline review form */
        .review-inline {
            margin-top: 12px;
            padding: 14px;
            background: var(--bg-elevated);
            border-radius: var(--radius-md);
            border: 1px solid var(--border-subtle);
            display: none;
            animation: fadeIn 0.25s ease;
        }
        .review-inline.open { display: block; }
        .review-inline .star-input {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 4px;
            margin-bottom: 10px;
        }
        .review-inline .star-input input { display: none; }
        .review-inline .star-input label {
            font-size: 22px;
            color: var(--text-muted);
            cursor: pointer;
            transition: color var(--transition-fast);
        }
        .review-inline .star-input label:hover,
        .review-inline .star-input label:hover ~ label,
        .review-inline .star-input input:checked ~ label {
            color: #f0c040;
        }
        .review-inline textarea {
            width: 100%;
            background: var(--bg-surface);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-sm);
            color: var(--text-primary);
            padding: 10px 12px;
            font-size: 13px;
            resize: vertical;
            min-height: 60px;
            font-family: 'Inter', sans-serif;
        }
        .review-inline textarea:focus {
            outline: none;
            border-color: var(--border-gold-strong);
            box-shadow: 0 0 0 3px rgba(212,175,55,0.06);
        }
        .review-inline .review-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .btn-review-submit {
            padding: 8px 20px;
            background: linear-gradient(135deg, var(--gold), var(--gold-dark));
            color: #101010;
            border: none;
            border-radius: 20px;
            font-weight: 600;
            font-size: 12px;
            cursor: pointer;
            transition: all var(--transition-base);
        }
        .btn-review-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(212,175,55,0.25);
        }
        .btn-review-cancel {
            padding: 8px 20px;
            background: transparent;
            color: var(--text-muted);
            border: 1px solid var(--border-subtle);
            border-radius: 20px;
            font-weight: 500;
            font-size: 12px;
            cursor: pointer;
            transition: all var(--transition-fast);
        }
        .btn-review-cancel:hover {
            background: rgba(255,255,255,0.04);
            color: var(--text-secondary);
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(6px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<div class="profile-wrapper">

    <!-- Sidebar chung -->
    <%@ include file="/common/user-sidebar.jsp" %>

    <%-- MAIN CONTENT --%>
    <div class="main-content">

        <div class="content-header">
            <div>
                <h1>Chi tiết đơn hàng #${order.id}</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                            <i class="bi bi-chevron-right"></i>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/order">Đơn hàng</a>
                            <i class="bi bi-chevron-right"></i>
                        </li>
                        <li class="breadcrumb-item active">Chi tiết #${order.id}</li>
                    </ol>
                </nav>
            </div>

            <div>
                <c:choose>
                    <c:when test="${order.orderStatus == 'PENDING'}">
                        <span class="status-badge status-pending">
                            <i class="bi bi-clock"></i> Chờ xác nhận
                        </span>
                    </c:when>
                    <c:when test="${order.orderStatus == 'SHIPPING' || fn:contains(order.orderStatus, 'Đang vận chuyển')}">
                        <span class="status-badge status-shipping">
                            <i class="bi bi-truck"></i> Đang giao hàng
                        </span>
                        <div style="margin-top:12px;">
                            <form action="${pageContext.request.contextPath}/confirm-received" method="POST" style="display:inline;">
                                <input type="hidden" name="id" value="${order.id}">
                                <button type="submit" class="btn btn-success btn-sm"
                                        style="border-radius:20px; padding:8px 20px; font-weight:600;
                                               background:#22c55e; border-color:#22c55e;"
                                        onclick="return confirm('Bạn xác nhận đã nhận được hàng?')">
                                    <i class="bi bi-check-circle-fill"></i> Đã nhận được hàng
                                </button>
                            </form>
                        </div>
                    </c:when>
                    <c:when test="${order.orderStatus == 'COMPLETED'}">
                        <span class="status-badge status-completed">
                            <i class="bi bi-check-circle-fill"></i> Đã giao thành công
                        </span>
                    </c:when>
                    <c:when test="${order.orderStatus == 'CANCELLED'}">
                        <span class="status-badge status-cancelled">
                            <i class="bi bi-x-circle-fill"></i> Đã hủy
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge status-pending">
                            <i class="bi bi-info-circle-fill"></i> ${order.orderStatus}
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- INFO CARDS --%>
        <div class="order-info-grid">
            <div class="info-card">
                <h4><i class="bi bi-geo-alt-fill"></i> Thông tin nhận hàng</h4>

                <div class="info-row">
                    <i class="bi bi-geo-alt"></i>
                    <span>${order.shippingAddress}</span>
                </div>
                <c:if test="${not empty order.note}">
                <div class="info-row">
                    <i class="bi bi-sticky"></i>
                    <span>Ghi chú: <strong>${order.note}</strong></span>
                </div>
                </c:if>
            </div>

            <%-- CHỮ KÝ SỐ --%>
            <div class="info-card">
                <h4><i class="bi bi-shield-lock"></i> Chữ ký số</h4>
                <div class="info-row">
                    <i class="bi bi-shield-check"></i>
                    <span>Trạng thái: 
                        <c:choose>
                            <c:when test="${verificationStatus == 'Verified'}">
                                <span class="sig-status sig-verified"><i class="bi bi-check-circle-fill"></i> ✓ Đã xác thực chữ ký</span>
                            </c:when>
                            <c:when test="${verificationStatus == 'Tampered'}">
                                <span class="sig-status sig-tampered"><i class="bi bi-exclamation-triangle-fill"></i> ⚠ đã bị chỉnh sửa</span>
                            </c:when>
                            <c:otherwise>
                                <span class="sig-status sig-unverified"><i class="bi bi-dash-circle"></i> - Chưa xác thực chữ ký</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-row">
                    <i class="bi bi-key"></i>
                    <span>Mã khóa: 
                        <strong>
                            <c:choose>
                                <c:when test="${order.keyId > 0}">#${order.keyId}</c:when>
                                <c:otherwise>Chưa ký</c:otherwise>
                            </c:choose>
                        </strong>
                    </span>
                </div>
                <c:if test="${verificationStatus != 'Verified'}">
                <div style="margin-top: 12px; display: flex; gap: 8px; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/sign-order?id=${order.id}" class="btn-back" style="padding: 6px 16px; font-size: 12px;">
                        <i class="bi bi-pen"></i> Ký đơn hàng
                    </a>
                </div>
                </c:if>
            </div>

            <div class="info-card">
                <h4><i class="bi bi-credit-card-2-front"></i> Thanh toán &amp; Vận chuyển</h4>
                <div class="info-row">
                    <i class="bi bi-credit-card"></i>
                    <span>Phương thức: <strong>
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'COD'}">Thanh toán khi nhận hàng (COD)</c:when>
                            <c:otherwise>Chuyển khoản ngân hàng</c:otherwise>
                        </c:choose>
                    </strong></span>
                </div>
                <div class="info-row">
                    <i class="bi bi-calendar3"></i>
                    <span>Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>
                <div class="info-row">
                    <i class="bi bi-truck"></i>
                    <span>Phí vận chuyển: 
                        <strong>
                            <c:choose>
                                <c:when test="${order.shippingFee > 0}">
                                    <fmt:formatNumber value="${order.shippingFee}" type="number" groupingUsed="true"/> &#8363;
                                </c:when>
                                <c:otherwise>
                                    Miễn phí
                                </c:otherwise>
                            </c:choose>
                        </strong>
                    </span>
                </div>
                <c:if test="${not empty order.shippingMethod}">
                <div class="info-row">
                    <i class="bi bi-truck"></i>
                    <span>Phương thức giao hàng: <strong>${order.shippingMethod}</strong></span>
                </div>
                </c:if>
                <%-- Tính toán ngày giao dự kiến từ ngày đặt hàng --%>
                <c:if test="${!fn:contains(order.orderStatus, 'Đã huỷ') && !fn:contains(order.orderStatus, 'Đã hủy') && order.orderStatus != 'CANCELLED' && !fn:contains(order.orderStatus, 'Đã giao') && order.orderStatus != 'DELIVERED' && order.orderStatus != 'COMPLETED'}">
                <%
                    code.salecar.model.Order ord = (code.salecar.model.Order) pageContext.findAttribute("order");
                    if (ord != null && ord.getOrderDate() != null) {
                        java.util.Calendar cal = java.util.Calendar.getInstance();
                        cal.setTime(ord.getOrderDate());
                        cal.add(java.util.Calendar.DAY_OF_MONTH, 5);
                        pageContext.setAttribute("estFrom", cal.getTime());
                        cal.add(java.util.Calendar.DAY_OF_MONTH, 3);
                        pageContext.setAttribute("estTo", cal.getTime());
                    }
                %>
                <div class="info-row">
                    <i class="bi bi-clock"></i>
                    <span>Nhận hàng dự kiến:
                        <strong>
                            <c:choose>
                                <c:when test="${fn:contains(order.orderStatus, 'SHIPPING') || fn:contains(order.orderStatus, 'Đang vận chuyển')}">
                                    <fmt:formatDate value="${estFrom}" pattern="dd/MM"/> – <fmt:formatDate value="${estTo}" pattern="dd/MM/yyyy"/>
                                    <span style="color:#0284c7; font-size:12px; font-weight:400;">(Đang giao)</span>
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatDate value="${estFrom}" pattern="dd/MM"/> – <fmt:formatDate value="${estTo}" pattern="dd/MM/yyyy"/>
                                </c:otherwise>
                            </c:choose>
                        </strong>
                    </span>
                </div>
                </c:if>
            </div>
        </div>

        <%-- TABLE --%>
        <div class="order-card">
            <div style="overflow-x:auto;">
                <table class="lux-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th style="text-align:center;">Đơn giá</th>
                            <th style="text-align:center;">Số lượng</th>
                            <th style="text-align:right; padding-right:24px;">Thành tiền</th>
                            <th style="text-align:center;">Đánh giá</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${order.items}">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}"
                                       class="product-link">
                                        <div class="product-img">
                                            <img src="${not empty item.imageUrl ? pageContext.request.contextPath.concat('/uploads/').concat(item.imageUrl) : 'https://placehold.co/100?text=LUXCAR'}"
                                                 alt="${item.product.name}"
                                                 onerror="this.src='https://placehold.co/100?text=LUXCAR'">
                                        </div>
                                        <div>
                                            <div class="product-name">${item.product.name}</div>
                                            <div class="product-meta">ID: LUX-${item.productId}</div>
                                        </div>
                                    </a>
                                </td>
                                <td class="price-cell" style="text-align:center;">
                                    <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> &#8363;
                                </td>
                                <td style="text-align:center; color:#777;">
                                    ${item.quantity}
                                </td>
                                <td class="total-cell" style="text-align:right; padding-right:24px;">
                                    <fmt:formatNumber value="${item.totalPrice}" type="number" groupingUsed="true"/> &#8363;
                                </td>
                                <td style="text-align:center; vertical-align:middle; min-width:130px;">
                                    <%-- Kiểm tra đơn hàng đã giao thành công --%>
                                    <c:set var="isDelivered" value="${order.orderStatus == 'DELIVERED' || order.orderStatus == 'COMPLETED' || fn:contains(order.orderStatus, 'Đã giao')}" />
                                    
                                    <c:choose>
                                        <%-- Đã giao và chưa đánh giá --%>
                                        <c:when test="${isDelivered and not reviewedProductIds.contains(item.productId)}">
                                            <span class="review-badge pending" 
                                                  onclick="toggleReviewForm('review-form-${item.productId}')">
                                                <i class="bi bi-star"></i> Đánh giá
                                            </span>
                                            <div class="review-inline" id="review-form-${item.productId}">
                                                <form action="${pageContext.request.contextPath}/reviews" method="post">
                                                    <input type="hidden" name="productId" value="${item.product.id}">
                                                    <input type="hidden" name="orderId" value="${order.id}">
                                                    
                                                    <div class="star-input">
                                                        <input type="radio" name="rating" value="5" id="star5-${item.productId}" required>
                                                        <label for="star5-${item.productId}" title="5 sao">★</label>
                                                        <input type="radio" name="rating" value="4" id="star4-${item.productId}">
                                                        <label for="star4-${item.productId}" title="4 sao">★</label>
                                                        <input type="radio" name="rating" value="3" id="star3-${item.productId}">
                                                        <label for="star3-${item.productId}" title="3 sao">★</label>
                                                        <input type="radio" name="rating" value="2" id="star2-${item.productId}">
                                                        <label for="star2-${item.productId}" title="2 sao">★</label>
                                                        <input type="radio" name="rating" value="1" id="star1-${item.productId}">
                                                        <label for="star1-${item.productId}" title="1 sao">★</label>
                                                    </div>
                                                    
                                                    <textarea name="comment" placeholder="Chia sẻ cảm nhận của bạn về sản phẩm..." rows="2"></textarea>
                                                    
                                                    <div class="review-actions">
                                                        <button type="submit" class="btn-review-submit">
                                                            <i class="bi bi-send"></i> Gửi đánh giá
                                                        </button>
                                                        <button type="button" class="btn-review-cancel" 
                                                                onclick="toggleReviewForm('review-form-${item.productId}')">
                                                            Hủy
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:when>
                                        <%-- Đã giao và đã đánh giá --%>
                                        <c:when test="${isDelivered and reviewedProductIds.contains(item.productId)}">
                                            <span class="review-badge done">
                                                <i class="bi bi-check-circle-fill"></i> Đã đánh giá
                                            </span>
                                        </c:when>
                                        <%-- Chưa giao hàng --%>
                                        <c:otherwise>
                                            <span class="review-badge na">
                                                <i class="bi bi-clock"></i> Chờ giao
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="order-summary">
                <div class="summary-inner">
                    <%-- Tính tạm tính = tổng tiền - phí ship --%>
                    <c:set var="subtotal" value="${order.totalAmount - order.shippingFee}" />
                    <div class="summary-row">
                        <span>Tạm tính:</span>
                        <span><fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true"/> &#8363;</span>
                    </div>
                    <div class="summary-row">
                        <span>Phí vận chuyển:</span>
                        <span style="font-weight:600;">
                            <c:choose>
                                <c:when test="${order.shippingFee > 0}">
                                    <fmt:formatNumber value="${order.shippingFee}" type="number" groupingUsed="true"/> &#8363;
                                </c:when>
                                <c:otherwise>
                                    <span style="color:var(--green);">Miễn phí</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="summary-row total">
                        <span>Tổng cộng:</span>
                        <span class="total-val">
                            <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> &#8363;
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <div>
            <a href="${pageContext.request.contextPath}/order" class="btn-back">
                <i class="bi bi-arrow-left"></i> Quay lại danh sách đơn hàng
            </a>
        </div>

    </div>
</div>

<!-- PASTE SIGNATURE MODAL -->
<div class="modal fade" id="pasteSigModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background: var(--bg-surface); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg);">
            <div class="modal-header" style="border-bottom: 1px solid var(--border-subtle);">
                <h5 class="modal-title"><i class="bi bi-clipboard me-2" style="color: var(--gold);"></i> Dán chữ ký số</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" style="filter: invert(1);"></button>
            </div>
            <form id="pasteSignatureDetailForm">
                <div class="modal-body">
                    <p style="color: var(--text-muted); font-size: 14px;">Dán chữ ký số từ Công cụ ký số vào ô bên dưới.</p>
                    <input type="hidden" name="orderId" id="pasteDetailOrderId" value="">
                    <input type="hidden" name="action" value="paste">
                    <textarea name="signature" id="pasteDetailSignatureInput" class="form-control"
                              style="background: var(--bg-elevated); border: 1.5px solid var(--border-subtle); color: var(--text-primary); min-height: 80px; font-family: 'Courier New', monospace; font-size: 12px;"
                              placeholder="Dán chữ ký số vào đây..." required></textarea>
                    <div id="pasteDetailSigMessage" style="margin-top: 10px; font-size: 13px; display: none;"></div>
                </div>
                <div class="modal-footer" style="border-top: 1px solid var(--border-subtle);">
                    <button type="button" class="btn-back" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn-back" style="border: none; background: linear-gradient(135deg, var(--gold), var(--gold-dark)); color: #101010;">
                        <i class="bi bi-check2-circle"></i> Xác nhận & Ký
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
// ========================
// TOAST NOTIFICATIONS
// ========================
function showToast(type, message) {
    var container = document.getElementById('toastContainer');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toastContainer';
        container.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999;';
        document.body.appendChild(container);
    }
    var toast = document.createElement('div');
    var bgColor = type === 'success' ? '#d1fae5' : '#fee2e2';
    var textColor = type === 'success' ? '#065f46' : '#b91c1c';
    var icon = type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill';
    toast.style.cssText = 'min-width: 320px; padding: 16px 24px; border-radius: 12px; font-weight: 600; font-size: 14px; box-shadow: 0 8px 24px rgba(0,0,0,0.15); display: flex; align-items: center; gap: 10px; margin-bottom: 10px; background: ' + bgColor + '; color: ' + textColor + '; border: 1px solid ' + (type === 'success' ? '#bbf7d0' : '#fecaca') + '; animation: slideInRight 0.3s ease;';
    toast.innerHTML = '<i class="bi ' + icon + '"></i> ' + message;
    container.appendChild(toast);
    setTimeout(function() {
        toast.style.opacity = '0';
        toast.style.transition = 'opacity 0.3s';
        setTimeout(function() { toast.remove(); }, 300);
    }, 4000);
}

// ========================
// PASTE SIGNATURE MODAL
// ========================
function openPasteModal(orderId) {
    document.getElementById('pasteDetailOrderId').value = orderId;
    document.getElementById('pasteDetailSigMessage').style.display = 'none';
    document.getElementById('pasteDetailSignatureInput').value = '';
    var pasteModal = new bootstrap.Modal(document.getElementById('pasteSigModal'));
    pasteModal.show();
}

document.addEventListener('DOMContentLoaded', function() {
    var pasteForm = document.getElementById('pasteSignatureDetailForm');
    if (pasteForm) {
        pasteForm.addEventListener('submit', function(e) {
            e.preventDefault();
            var orderId = document.getElementById('pasteDetailOrderId').value;
            var signature = document.getElementById('pasteDetailSignatureInput').value.trim();
            var msgEl = document.getElementById('pasteDetailSigMessage');

            if (!signature) {
                msgEl.style.display = 'block';
                msgEl.style.color = '#e74c3c';
                msgEl.textContent = 'Vui lòng dán chữ ký số!';
                return;
            }

            var formData = new URLSearchParams();
            formData.append('action', 'paste');
            formData.append('orderId', orderId);
            formData.append('signature', signature);

            fetch('${pageContext.request.contextPath}/sign-order', {
                method: 'POST',
                body: formData
            })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.success) {
                    msgEl.style.display = 'block';
                    msgEl.style.color = '#2ecc71';
                    msgEl.textContent = data.message;
                    setTimeout(function() { window.location.reload(); }, 1500);
                } else {
                    msgEl.style.display = 'block';
                    msgEl.style.color = '#e74c3c';
                    msgEl.textContent = data.message;
                }
            })
            .catch(function(err) {
                msgEl.style.display = 'block';
                msgEl.style.color = '#e74c3c';
                msgEl.textContent = 'Lỗi kết nối máy chủ!';
            });
        });
    }
});

// ========================
// TAMPER DETECTION ON LOAD
// ========================
<c:if test="${not empty tamperedOrders}">
(function() {
    <c:forEach var="tamper" items="${tamperedOrders}">                showToast('error', 'Cảnh báo: Đơn hàng #' + ${tamper.orderId} + ' đặt ngày "<fmt:formatDate value='${tamper.orderDate}' pattern='dd/MM/yyyy HH:mm' />" đã bị thay đổi dữ liệu trái phép! Hãy kiểm tra ngay.');
    </c:forEach>
})();
</c:if>

function toggleReviewForm(formId) {
    var targetForm = document.getElementById(formId);
    if (!targetForm) return;

    // Nếu form target đang mở → đóng nó lại
    if (targetForm.classList.contains('open')) {
        targetForm.classList.remove('open');
        return;
    }

    // Đóng tất cả các form khác trước khi mở form mới
    var allForms = document.querySelectorAll('.review-inline.open');
    allForms.forEach(function(f) {
        f.classList.remove('open');
    });

    // Mở form target
    targetForm.classList.add('open');
}
</script>

</body>
</html>
