<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đặt hàng thành công - LUXCAR</title>

    <%@ include file="/common/header.jsp" %>

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/common/dark-theme.css">

    <style>
        /* ================= OVERRIDE MAIN CONTENT FOR SUCCESS LAYOUT ================= */
        .success-content {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 0;
            background: var(--bg-primary);
        }
        /* ================= SUCCESS PAGE ================= */
        .success-wrapper {
            min-height: calc(100vh - 100px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            background: var(--bg-primary);
        }

        .success-card {
            max-width: 560px;
            width: 100%;
            background: var(--bg-surface);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-gold);
            box-shadow: var(--shadow-card);
            padding: 50px 40px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        /* Decorative top border */
        .success-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--gold-dark), var(--gold), var(--gold-light), var(--gold), var(--gold-dark));
            background-size: 200% 100%;
            animation: shimmer 3s ease-in-out infinite;
        }

        @keyframes shimmer {
            0%, 100% { background-position: 0% 0%; }
            50% { background-position: 100% 0%; }
        }

        /* ================= ANIMATED CHECKMARK ================= */
        .checkmark-circle {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.15), rgba(212, 175, 55, 0.05));
            border: 3px solid var(--gold);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            position: relative;
            animation: pulseGlow 2s ease-in-out infinite;
        }

        @keyframes pulseGlow {
            0%, 100% { box-shadow: 0 0 20px rgba(212, 175, 55, 0.15); }
            50% { box-shadow: 0 0 40px rgba(212, 175, 55, 0.30), 0 0 60px rgba(212, 175, 55, 0.10); }
        }

        .checkmark-circle i {
            font-size: 42px;
            color: var(--gold);
            animation: checkBounce 0.6s cubic-bezier(0.68, -0.55, 0.27, 1.55) both;
        }

        @keyframes checkBounce {
            0% { transform: scale(0); opacity: 0; }
            60% { transform: scale(1.2); }
            100% { transform: scale(1); opacity: 1; }
        }

        /* ================= CONTENT ================= */
        .success-title {
            font-family: 'Playfair Display', serif;
            font-size: 28px;
            font-weight: 700;
            color: var(--gold);
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }

        .success-subtitle {
            font-size: 15px;
            color: var(--text-secondary);
            margin-bottom: 30px;
            line-height: 1.6;
        }

        /* ================= ORDER INFO CARD ================= */
        .order-info-mini {
            background: var(--bg-elevated);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            padding: 20px 24px;
            margin-bottom: 30px;
            text-align: left;
        }

        .order-info-mini .row-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
        }

        .order-info-mini .row-item + .row-item {
            border-top: 1px dashed var(--border-subtle);
        }

        .order-info-mini .label {
            font-size: 13px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .order-info-mini .label i {
            color: var(--gold);
            width: 16px;
        }

        .order-info-mini .value {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-primary);
        }

        .order-info-mini .value.gold {
            color: var(--gold);
            font-size: 16px;
        }

        .order-info-mini .value .order-id-link {
            color: var(--gold);
            text-decoration: none;
            transition: color var(--transition-fast);
        }

        .order-info-mini .value .order-id-link:hover {
            color: var(--gold-light);
            text-decoration: underline;
        }

        /* ================= NEXT STEPS ================= */
        .next-steps {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 30px;
        }

        .step-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 12px 16px;
            background: var(--bg-elevated);
            border-radius: var(--radius-sm);
            border: 1px solid var(--border-subtle);
            text-align: left;
            transition: all var(--transition-fast);
        }

        .step-item:hover {
            border-color: var(--border-gold);
            transform: translateX(4px);
        }

        .step-number {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: rgba(212, 175, 55, 0.12);
            border: 1px solid rgba(212, 175, 55, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
            color: var(--gold);
            flex-shrink: 0;
        }

        .step-text {
            font-size: 13px;
            color: var(--text-secondary);
            line-height: 1.4;
        }

        .step-text strong {
            color: var(--text-primary);
        }

        /* ================= BUTTONS ================= */
        .success-actions {
            display: flex;
            gap: 12px;
        }

        .btn-view-order {
            flex: 1;
            background: linear-gradient(135deg, var(--gold), var(--gold-dark));
            color: #101010;
            border: none;
            padding: 14px 24px;
            border-radius: 40px;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all var(--transition-base);
            cursor: pointer;
        }

        .btn-view-order:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(212, 175, 55, 0.3);
            color: #101010;
        }

        .btn-continue {
            flex: 1;
            background: transparent;
            color: var(--gold);
            border: 1.5px solid var(--border-gold);
            padding: 14px 24px;
            border-radius: 40px;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all var(--transition-base);
            cursor: pointer;
        }

        .btn-continue:hover {
            background: rgba(212, 175, 55, 0.06);
            color: var(--gold-light);
            transform: translateY(-2px);
        }

        /* ================= PAYMENT METHOD BADGE ================= */
        .payment-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .payment-badge.cod {
            background: rgba(46, 204, 113, 0.12);
            color: #2ecc71;
            border: 1px solid rgba(46, 204, 113, 0.2);
        }

        .payment-badge.vnpay {
            background: rgba(52, 152, 219, 0.12);
            color: #3498db;
            border: 1px solid rgba(52, 152, 219, 0.2);
        }

        /* ================= RESPONSIVE ================= */
        @media (max-width: 576px) {
            .success-card {
                padding: 30px 20px 24px;
            }

            .success-title {
                font-size: 22px;
            }

            .success-actions {
                flex-direction: column;
            }

            .checkmark-circle {
                width: 70px;
                height: 70px;
            }

            .checkmark-circle i {
                font-size: 32px;
            }
        }

        /* ================= PARTICLE EFFECT ================= */
        .confetti-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 9999;
            overflow: hidden;
        }

        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            opacity: 0;
            animation: confettiFall 3s ease-in-out forwards;
        }

        @keyframes confettiFall {
            0% {
                transform: translateY(-20px) rotate(0deg) scale(0);
                opacity: 1;
            }
            50% {
                opacity: 0.8;
            }
            100% {
                transform: translateY(100vh) rotate(720deg) scale(1);
                opacity: 0;
            }
        }
    </style>
</head>
<body>

<div class="profile-wrapper">
    <!-- Sidebar -->
    <%@ include file="/common/user-sidebar.jsp" %>

    <!-- Main content -->
    <div class="main-content success-content">

        <!-- Confetti particles -->
        <div class="confetti-container" id="confettiContainer"></div>

        <div class="success-card">

            <!-- Animated checkmark -->
            <div class="checkmark-circle">
                <i class="bi bi-check-lg"></i>
            </div>

            <!-- Title -->
            <h1 class="success-title">Đặt hàng thành công!</h1>
            <p class="success-subtitle">
                Cảm ơn bạn đã đặt hàng tại <strong style="color: var(--gold);">LUXCAR</strong>.
                Đơn hàng của bạn đã được ghi nhận và đang chờ xử lý.
            </p>

            <!-- Order info -->
            <div class="order-info-mini">
                <div class="row-item">
                    <span class="label"><i class="bi bi-receipt"></i> Mã đơn hàng</span>
                    <span class="value">
                        <a href="${pageContext.request.contextPath}/order-detail?id=${order.id}" class="order-id-link">
                            #${order.id}
                        </a>
                    </span>
                </div>
                <div class="row-item">
                    <span class="label"><i class="bi bi-calendar3"></i> Ngày đặt</span>
                    <span class="value"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>
                <div class="row-item">
                    <span class="label"><i class="bi bi-credit-card"></i> Thanh toán</span>
                    <span class="value">
                        <span class="payment-badge ${order.paymentMethod == 'VNPAY' ? 'vnpay' : 'cod'}">
                            <i class="bi ${order.paymentMethod == 'VNPAY' ? 'bi-wifi' : 'bi-cash'}"></i>
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'VNPAY'}">VNPAY</c:when>
                                <c:otherwise>COD</c:otherwise>
                            </c:choose>
                        </span>
                    </span>
                </div>
                <div class="row-item">
                    <span class="label"><i class="bi bi-truck"></i> Phí vận chuyển</span>
                    <span class="value">
                        <c:choose>
                            <c:when test="${order.shippingFee > 0}">
                                <fmt:formatNumber value="${order.shippingFee}" type="number" groupingUsed="true"/> ₫
                            </c:when>
                            <c:otherwise>Miễn phí</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="row-item">
                    <span class="label"><i class="bi bi-wallet2"></i> Tổng tiền</span>
                    <span class="value gold"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫</span>
                </div>
            </div>

            <!-- Next steps -->
            <div class="next-steps">
                <div class="step-item">
                    <div class="step-number">1</div>
                    <div class="step-text">
                        <strong>Xác nhận đơn hàng</strong> — Chúng tôi sẽ xác nhận đơn hàng trong thời gian sớm nhất.
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-number">2</div>
                    <div class="step-text">
                        <strong>Đóng gói &amp; Vận chuyển</strong> — Sản phẩm sẽ được đóng gói và giao đến địa chỉ của bạn.
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-number">3</div>
                    <div class="step-text">
                        <strong>Nhận hàng &amp; Kiểm tra</strong> — Kiểm tra sản phẩm khi nhận và thanh toán (nếu chọn COD).
                    </div>
                </div>
            </div>

            <!-- Actions -->
            <div class="success-actions">
                <a href="${pageContext.request.contextPath}/order-detail?id=${order.id}" class="btn-view-order">
                    <i class="bi bi-info-circle"></i> Xem chi tiết đơn hàng
                </a>
                <a href="${pageContext.request.contextPath}/home" class="btn-continue">
                    <i class="bi bi-arrow-right"></i> Tiếp tục mua sắm
                </a>
            </div>

        </div>
    </div>
</div>

<script>
    // ========================
    // CONFETTI PARTICLE EFFECT
    // ========================
    document.addEventListener('DOMContentLoaded', function() {
        var container = document.getElementById('confettiContainer');
        var colors = ['#D4AF37', '#b8960f', '#e9d6b0', '#FFD700', '#FFF8DC', '#F0E68C'];

        for (var i = 0; i < 40; i++) {
            var confetti = document.createElement('div');
            confetti.className = 'confetti';
            confetti.style.left = Math.random() * 100 + '%';
            confetti.style.top = '-10px';
            confetti.style.background = colors[Math.floor(Math.random() * colors.length)];
            confetti.style.width = (Math.random() * 6 + 4) + 'px';
            confetti.style.height = (Math.random() * 6 + 4) + 'px';
            confetti.style.borderRadius = Math.random() > 0.5 ? '50%' : '2px';
            confetti.style.animationDelay = (Math.random() * 2) + 's';
            confetti.style.animationDuration = (Math.random() * 2 + 2) + 's';
            container.appendChild(confetti);
        }

        // Remove confetti after animation completes
        setTimeout(function() {
            if (container && container.parentNode) {
                container.parentNode.removeChild(container);
            }
        }, 5000);
    });

    // Safely handle confetti cleanup
    window.addEventListener('beforeunload', function() {
        var container = document.getElementById('confettiContainer');
        if (container && container.parentNode) {
            container.parentNode.removeChild(container);
        }
    });
    });
</script>

</body>
</html>
