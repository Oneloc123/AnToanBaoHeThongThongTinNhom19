<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý khóa - LUXCAR</title>
    <%@ include file="/common/header.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/common/dark-theme.css">
    <style>
        .main-content { flex: 1; padding: 30px 40px; background: var(--bg-primary); }
        .content-header h1 { font-family: 'Playfair Display', serif; }

        .key-card {
            background: var(--bg-surface);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-subtle);
            padding: 28px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-card);
        }
        .key-card h3 {
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
        .key-card h3 i { color: var(--gold); }

        .key-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .key-status.active { background: rgba(46,204,113,0.12); color: #2ecc71; border: 1px solid rgba(46,204,113,0.2); }
        .key-status.revoked { background: rgba(231,76,60,0.12); color: #e74c3c; border: 1px solid rgba(231,76,60,0.2); }
        .key-status.none { background: rgba(255,193,7,0.12); color: #ffc107; border: 1px solid rgba(255,193,7,0.2); }

        .key-detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-subtle);
        }
        .key-detail-row:last-child { border-bottom: none; }
        .key-detail-label { color: var(--text-muted); font-size: 13px; }
        .key-detail-value { color: var(--text-primary); font-size: 13px; font-weight: 500; text-align: right; max-width: 60%; word-break: break-all; }

        .key-public-key-display {
            background: var(--bg-elevated);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-sm);
            padding: 12px;
            font-family: 'Courier New', monospace;
            font-size: 11px;
            color: var(--text-secondary);
            max-height: 100px;
            overflow-y: auto;
            word-break: break-all;
            margin-top: 8px;
        }

        .btn-key-action {
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
        .btn-key-revoke {
            background: rgba(231,76,60,0.12);
            border: 1.5px solid rgba(231,76,60,0.3);
            color: #e74c3c;
        }
        .btn-key-revoke:hover { background: rgba(231,76,60,0.2); transform: translateY(-1px); }
        .btn-key-update {
            background: linear-gradient(135deg, var(--gold), var(--gold-dark));
            color: #101010;
        }
        .btn-key-update:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(212,175,55,0.25); }
        .btn-key-update:disabled { opacity: 0.5; cursor: not-allowed; transform: none !important; }

        .key-textarea {
            width: 100%;
            min-height: 120px;
            background: var(--bg-elevated);
            border: 1.5px solid var(--border-subtle);
            border-radius: var(--radius-sm);
            color: var(--text-primary);
            padding: 12px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            resize: vertical;
        }
        .key-textarea:focus {
            outline: none;
            border-color: var(--border-gold-strong);
            box-shadow: 0 0 0 3px rgba(212,175,55,0.06);
        }

        .history-table { width: 100%; border-collapse: collapse; }
        .history-table th {
            padding: 12px 10px;
            border-bottom: 2px solid var(--border-gold);
            text-align: left;
            font-size: 11px;
            color: var(--text-primary);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .history-table td {
            padding: 14px 10px;
            border-bottom: 1px dashed var(--border-subtle);
            font-size: 13px;
            color: var(--text-secondary);
        }
        .history-table tbody tr:hover td { background: var(--bg-elevated); }

        .tool-download-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 22px;
            background: var(--bg-surface);
            border: 1.5px solid var(--border-gold);
            color: var(--gold);
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
            transition: all var(--transition-fast);
            cursor: pointer;
        }
        .tool-download-link:hover {
            background: linear-gradient(135deg, var(--gold), var(--gold-dark));
            color: #101010;
            transform: translateY(-1px);
        }

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
            <h1><i class="bi bi-shield-lock"></i> Quản lý khóa</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a> <i class="bi bi-chevron-right"></i></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard">Bảng điều khiển</a> <i class="bi bi-chevron-right"></i></li>
                    <li class="breadcrumb-item active">Quản lý khóa</li>
                </ol>
            </nav>
        </div>

        <!-- Công cụ ký số -->
        <div class="key-card">
            <h3><i class="bi bi-download"></i> Công cụ ký số (Offline Signing Tool)</h3>
            <p style="color: var(--text-secondary); font-size: 14px; margin-bottom: 15px;">
                Tải công cụ ký số RSA để ký đơn hàng ngoại tuyến.
            </p>
            <a href="#" class="tool-download-link" onclick="showToast('info', 'Vui lòng chạy lớp Main.java trong gói tool từ IDE của bạn.'); return false;">
                <i class="bi bi-file-earmark-zip"></i> Tải công cụ
            </a>
        </div>

        <!-- Khóa hiện tại -->
        <div class="key-card">
            <h3><i class="bi bi-key"></i> Khóa hiện tại</h3>

            <c:choose>
                <c:when test="${not empty activeKey}">
                    <div class="key-detail-row">
                        <span class="key-detail-label">Trạng thái</span>
                        <span class="key-status active"><i class="bi bi-check-circle-fill"></i> Đang hoạt động</span>
                    </div>
                    <div class="key-detail-row">
                        <span class="key-detail-label">Mã khóa</span>
                        <span class="key-detail-value">#${activeKey.id}</span>
                    </div>
                    <div class="key-detail-row">
                        <span class="key-detail-label">Ngày tạo</span>
                        <span class="key-detail-value"><fmt:formatDate value="${activeKey.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
                    </div>
                    <div class="key-detail-row" style="flex-direction: column; align-items: flex-start;">
                        <span class="key-detail-label" style="margin-bottom: 8px;">Khóa công khai (Public Key - rút gọn)</span>
                        <div class="key-public-key-display">${activeKey.maskedPublicKey}</div>
                    </div>
                    <div style="margin-top: 20px;">
                        <form action="digital-keys" method="POST" style="display: inline;">
                            <input type="hidden" name="action" value="revoke">
                            <button type="submit" class="btn-key-action btn-key-revoke"
                                    onclick="return confirm('Bạn có chắc muốn thu hồi khóa này? Hành động này sẽ làm mất hiệu lực tất cả chữ ký đã tạo bằng khóa này.')">
                                <i class="bi bi-x-circle"></i> Báo mất / Thu hồi khóa
                            </button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="key-detail-row">
                        <span class="key-detail-label">Trạng thái</span>
                        <span class="key-status none"><i class="bi bi-exclamation-triangle"></i> Chưa có khóa</span>
                    </div>
                    <p style="color: var(--text-muted); font-size: 14px; margin: 15px 0;">
                        Bạn cần tải lên khóa công khai (Public Key) để có thể ký đơn hàng. Hãy tạo cặp khóa bằng Công cụ ký số ở trên.
                    </p>

                    <c:if test="${empty activeKey and (empty keyHistory or fn:length(keyHistory) == 0 or keyHistory[0].status == 'REVOKED')}">
                        <!-- Hiển thị form cập nhật -->
                        <form action="digital-keys" method="POST">
                            <input type="hidden" name="action" value="update">
                            <div class="form-group" style="margin-bottom: 15px;">
                                <!-- File upload button -->
                                <label style="display: block; color: var(--text-secondary); font-size: 13px; font-weight: 600; margin-bottom: 8px;">
                                    Tải lên file khóa công khai từ Công cụ ký số (public_key.txt):
                                </label>
                                <div class="file-upload-row">
                                    <input type="file" id="publicKeyFile" accept=".txt"
                                           style="display: none;" onchange="readPublicKeyFile(event)">
                                    <button type="button" class="btn-key-action btn-key-update"
                                            onclick="document.getElementById('publicKeyFile').click()">
                                        <i class="bi bi-file-earmark"></i> Chọn file
                                    </button>
                                    <span id="fileNameDisplay" style="color: var(--text-muted); font-size: 13px; margin-left: 10px;">Chưa chọn file</span>
                                </div>

                                <!-- Or paste manually -->
                                <label style="display: block; color: var(--text-secondary); font-size: 12px; font-weight: 500; margin: 15px 0 8px 0;">
                                    <i class="bi bi-pencil"></i> Hoặc dán trực tiếp nội dung khóa công khai (kèm theo các dấu <span style="background: var(--bg-elevated); padding: 1px 6px; border-radius: 3px; font-family: monospace; font-size: 11px;"><<BeginPublicKey>></span> / <span style="background: var(--bg-elevated); padding: 1px 6px; border-radius: 3px; font-family: monospace; font-size: 11px;"><<EndPublicKey>></span>):
                                </label>
                                <textarea name="publicKey" id="publicKeyTextarea" class="key-textarea"
                                          placeholder="<<BeginPublicKey>>&#10;...&#10;<<EndPublicKey>>" required></textarea>
                            </div>
                            <button type="submit" class="btn-key-action btn-key-update">
                                <i class="bi bi-upload"></i> Cập nhật khóa mới
                            </button>
                        </form>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Lịch sử khóa -->
        <div class="key-card">
            <h3><i class="bi bi-clock-history"></i> Lịch sử khóa</h3>

            <c:choose>
                <c:when test="${not empty keyHistory}">
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Ngày thu hồi</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="key" items="${keyHistory}">
                                <tr>
                                    <td>#${key.id}</td>
                                    <td>
                                        <span class="key-status ${key.status == 'ACTIVE' ? 'active' : 'revoked'}">
                                            ${key.status == 'ACTIVE' ? 'Hoạt động' : 'Đã thu hồi'}
                                        </span>
                                    </td>
                                    <td><fmt:formatDate value="${key.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty key.revokedAt}">
                                                <fmt:formatDate value="${key.revokedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                            </c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="button" class="btn-key-action btn-key-update"
                                                style="padding: 5px 14px; font-size: 11px;"
                                                onclick="viewKeyDetails('${key.maskedPublicKey}', '${key.status}', '${key.id}')">
                                            <i class="bi bi-eye"></i> Xem
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p style="color: var(--text-muted); text-align: center; padding: 30px;">
                        <i class="bi bi-inbox" style="font-size: 40px; display: block; margin-bottom: 10px;"></i>
                        Chưa có khóa nào. Hãy tạo cặp khóa đầu tiên bằng Công cụ ký số.
                    </p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Modal xem chi tiết khóa -->
<div class="modal fade" id="viewKeyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background: var(--bg-surface); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg);">
            <div class="modal-header" style="border-bottom: 1px solid var(--border-subtle);">
                <h5 class="modal-title"><i class="bi bi-key me-2" style="color: var(--gold);"></i> Chi tiết khóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" style="filter: invert(1);"></button>
            </div>
            <div class="modal-body">
                <div class="key-detail-row">
                    <span class="key-detail-label">Mã khóa</span>
                    <span class="key-detail-value" id="modalKeyId"></span>
                </div>
                <div class="key-detail-row">
                    <span class="key-detail-label">Trạng thái</span>
                    <span class="key-detail-value" id="modalKeyStatus"></span>
                </div>
                <div class="key-detail-row" style="flex-direction: column; align-items: flex-start;">
                    <span class="key-detail-label" style="margin-bottom: 8px;">Khóa công khai</span>
                    <div class="key-public-key-display" id="modalPublicKey" style="max-height: 200px;"></div>
                </div>
            </div>
            <div class="modal-footer" style="border-top: 1px solid var(--border-subtle);">
                <button type="button" class="btn-key-action btn-key-revoke" data-bs-dismiss="modal" style="padding: 8px 20px;">
                    Đóng
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Toast container for notifications -->
<div class="toast-container" id="toastContainer"></div>

<script>
    function viewKeyDetails(maskedKey, status, keyId) {
        document.getElementById('modalKeyId').textContent = '#' + keyId;
        document.getElementById('modalKeyStatus').innerHTML = '<span class="key-status ' + (status === 'ACTIVE' ? 'active' : 'revoked') + '">' + (status === 'ACTIVE' ? 'Hoạt động' : 'Đã thu hồi') + '</span>';
        document.getElementById('modalPublicKey').textContent = maskedKey;
        var modal = new bootstrap.Modal(document.getElementById('viewKeyModal'));
        modal.show();
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

    // Đọc file public key và điền vào textarea
    function readPublicKeyFile(event) {
        const file = event.target.files[0];
        if (!file) return;

        const fileNameSpan = document.getElementById('fileNameDisplay');
        fileNameSpan.textContent = file.name;

        const reader = new FileReader();
        reader.onload = function(e) {
            const content = e.target.result;
            document.getElementById('publicKeyTextarea').value = content;
        };
        reader.onerror = function() {
            showToast('error', 'Không thể đọc file. Vui lòng thử lại.');
        };
        reader.readAsText(file);
    }

    // Hiển thị toast từ session nếu có
    <c:if test="${not empty sessionScope.toastMessage}">
    (function() {
        var type = '${sessionScope.toastType}' === 'success' ? 'success' : 'error';
        showToast(type, '<c:out value="${sessionScope.toastMessage}" />');
    })();
    </c:if>
    <c:remove var="toastMessage" scope="session"/>
    <c:remove var="toastType" scope="session"/>
</script>
</body>
</html>
