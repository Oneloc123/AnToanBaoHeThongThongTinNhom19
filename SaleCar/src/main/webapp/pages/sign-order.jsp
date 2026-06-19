<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ký đơn hàng - LUXCAR</title>
    <%@ include file="/common/header.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/common/dark-theme.css">
    <style>
        .main-content { flex: 1; padding: 30px 40px; background: var(--bg-primary); }
        .content-header h1 { font-family: 'Playfair Display', serif; }

        .sign-card {
            background: var(--bg-surface);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-subtle);
            padding: 28px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-card);
        }
        .sign-card h3 {
            font-size: 18px;
            font-weight: 700;
            font-family: 'Playfair Display', serif;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(212,175,55,0.2);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .sign-card h3 i { color: var(--gold); }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid var(--border-subtle);
            font-size: 14px;
        }
        .info-row .label { color: var(--text-muted); }
        .info-row .value { color: var(--text-primary); font-weight: 500; }

        .hash-data-box {
            background: var(--bg-elevated);
            border: 1.5px solid var(--border-subtle);
            border-radius: var(--radius-sm);
            padding: 14px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            color: var(--text-secondary);
            word-break: break-all;
            line-height: 1.6;
            max-height: 150px;
            overflow-y: auto;
            margin-bottom: 10px;
        }

        .btn-sign-action {
            padding: 10px 24px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 13px;
            transition: all var(--transition-fast);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
        }
        .btn-sign-primary {
            background: linear-gradient(135deg, var(--gold), var(--gold-dark));
            color: #101010;
        }
        .btn-sign-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(212,175,55,0.25); }
        .btn-sign-secondary {
            background: transparent;
            border: 1.5px solid var(--border-gold);
            color: var(--gold);
        }
        .btn-sign-secondary:hover { background: rgba(212,175,55,0.08); }

        .sig-textarea {
            width: 100%;
            min-height: 80px;
            background: var(--bg-elevated);
            border: 1.5px solid var(--border-subtle);
            border-radius: var(--radius-sm);
            color: var(--text-primary);
            padding: 12px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            resize: vertical;
        }
        .sig-textarea:focus {
            outline: none;
            border-color: var(--border-gold-strong);
            box-shadow: 0 0 0 3px rgba(212,175,55,0.06);
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-verified { background: rgba(46,204,113,0.12); color: #2ecc71; border: 1px solid rgba(46,204,113,0.2); }
        .status-unverified { background: rgba(255,193,7,0.12); color: #ffc107; border: 1px solid rgba(255,193,7,0.2); }

        .breadcrumb-item i { color: var(--text-muted); font-size: 9px; }

        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }
        .lux-toast {
            min-width: 320px;
            padding: 16px 24px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 14px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideInRight 0.3s ease;
        }
        .lux-toast.success { background: #d1fae5; color: #065f46; border: 1px solid #bbf7d0; }
        .lux-toast.error { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>
<body>
<div class="profile-wrapper">
    <%@ include file="/common/user-sidebar.jsp" %>

    <div class="main-content">
        <div class="content-header">
            <h1><i class="bi bi-pen"></i> Ký đơn hàng #${order.id}</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a> <i class="bi bi-chevron-right"></i></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/order">Đơn hàng</a> <i class="bi bi-chevron-right"></i></li>
                    <li class="breadcrumb-item active">Ký #${order.id}</li>
                </ol>
            </nav>
        </div>

        <!-- Hướng dẫn -->
<%--        <div class="sign-card" style="background: rgba(212,175,55,0.04); border-color: var(--border-gold);">--%>
<%--            <h3><i class="bi bi-info-circle"></i> Cách ký đơn hàng</h3>--%>
<%--            <ol style="color: var(--text-secondary); font-size: 14px; line-height: 2.2;">--%>
<%--                <li>Mở <strong>Công cụ ký số</strong>.</li>--%>
<%--                <li>Ở Tab 1, tạo cặp khóa DSA và <strong>sao chép Public Key</strong> vào trang <a href="${pageContext.request.contextPath}/digital-keys" style="color: var(--gold);">Quản lý khóa</a> của bạn.</li>--%>
<%--                <li><strong>Sao chép</strong> chuỗi dữ liệu băm (Hash Data) bên dưới (nhấn nút sao chép).</li>--%>
<%--                <li>Chuyển sang <strong>Tab 2 (Ký đơn hàng)</strong> trong công cụ, dán <strong>Private Key</strong> và dữ liệu băm, sau đó nhấn <strong>"Ký"</strong>.</li>--%>
<%--                <li><strong>Sao chép</strong> chữ ký số được tạo ra và dán vào ô bên dưới, sau đó nhấn <strong>"Xác nhận ký"</strong>.</li>--%>
<%--            </ol>--%>
<%--        </div>--%>

        <!-- Thông tin đơn hàng -->
        <div class="sign-card">
            <h3><i class="bi bi-receipt"></i> Tóm tắt đơn hàng</h3>
            <div class="info-row"><span class="label">Mã đơn hàng</span><span class="value">#${order.id}</span></div>
            <div class="info-row"><span class="label">Ngày đặt</span><span class="value"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss"/></span></div>
            <div class="info-row"><span class="label">Tổng tiền</span><span class="value"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫</span></div>
            <div class="info-row"><span class="label">Trạng thái chữ ký</span>
                <span class="status-badge ${verificationStatus == 'Verified' ? 'status-verified' : 'status-unverified'}">
                    ${verificationStatus == 'Verified' ? '✓ Đã ký' : (verificationStatus == 'Tampered' ? '⚠ Giả mạo' : '○ Chưa ký')}
                </span>
            </div>
        </div>

        <!-- Danh sách sản phẩm -->
        <div class="sign-card">
            <h3><i class="bi bi-box"></i> Sản phẩm trong đơn</h3>
            <c:forEach var="item" items="${order.items}" varStatus="stat">
                <div class="info-row">
                    <span class="label">${stat.index + 1}. ${item.product.name}</span>
                    <span class="value">x${item.quantity} @ <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫</span>
                </div>
            </c:forEach>
        </div>

        <!-- Dữ liệu băm -->
        <div class="sign-card">
            <h3><i class="bi bi-hash"></i> Dữ liệu băm (Hash Data)</h3>
            <p style="color: var(--text-muted); font-size: 13px; margin-bottom: 10px;">
                Sao chép chuỗi này vào Công cụ ký số.
            </p>
            <div class="hash-data-box" id="hashDataDisplay">${hashData}</div>
            <button type="button" class="btn-sign-action btn-sign-secondary" onclick="copyHashData()">
                <i class="bi bi-clipboard"></i> Sao chép nhanh
            </button>
        </div>

        <!-- Nhập chữ ký -->
        <div class="sign-card">
            <h3><i class="bi bi-shield-check"></i> Dán chữ ký số</h3>
            <p style="color: var(--text-muted); font-size: 13px; margin-bottom: 10px;">
                Dán chữ ký số được tạo ra từ Công cụ ký số vào ô bên dưới.
            </p>

            <form action="sign-order" method="POST">
                <input type="hidden" name="action" value="sign">
                <input type="hidden" name="orderId" value="${order.id}">

                <textarea name="signature" class="sig-textarea" placeholder="Dán chữ ký số của bạn vào đây..." required></textarea>

                <div style="margin-top: 15px; display: flex; gap: 10px;">
                    <button type="submit" class="btn-sign-action btn-sign-primary">
                        <i class="bi bi-check2-circle"></i> Xác nhận ký
                    </button>
                    <a href="${pageContext.request.contextPath}/order-detail?id=${order.id}" class="btn-sign-action btn-sign-secondary" style="text-decoration: none;">
                        <i class="bi bi-arrow-left"></i> Quay lại đơn hàng
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Toast container for notifications -->
<div class="toast-container" id="toastContainer"></div>

<script>
    function copyHashData() {
        var hashData = document.getElementById('hashDataDisplay').textContent;
        navigator.clipboard.writeText(hashData).then(function() {
            showToast('success', 'Đã sao chép dữ liệu băm vào bộ nhớ tạm!');
        }).catch(function() {
            // Fallback
            var textArea = document.createElement('textarea');
            textArea.value = hashData;
            document.body.appendChild(textArea);
            textArea.select();
            document.execCommand('copy');
            document.body.removeChild(textArea);
            showToast('success', 'Đã sao chép dữ liệu băm vào bộ nhớ tạm!');
        });
    }

    function showToast(type, message) {
        var container = document.getElementById('toastContainer');
        var toast = document.createElement('div');
        toast.className = 'lux-toast ' + type;
        toast.innerHTML = '<i class="bi ' + (type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill') + '"></i> ' + message;
        container.appendChild(toast);
        setTimeout(function() {
            toast.style.opacity = '0';
            toast.style.transition = 'opacity 0.3s';
            setTimeout(function() { toast.remove(); }, 300);
        }, 4000);
    }

    // Show toast from session if present
    <c:if test="${not empty sessionScope.toastMessage}">
    (function() {
        var type = '${sessionScope.toastType}' === 'success' ? 'success' : 'error';
        showToast(type, '${sessionScope.toastMessage}');
    })();
    </c:if>
    <c:remove var="toastMessage" scope="session"/>
    <c:remove var="toastType" scope="session"/>
</script>
</body>
</html>
