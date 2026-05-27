<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản Lý Khóa Bảo Mật - LUXCAR</title>

    <%@ include file="/common/header.jsp" %>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <script src="${pageContext.request.contextPath}/common/assets/forge.min.js"></script>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }

        /* Main layout & Sidebar (Bắt buộc giữ nguyên cấu trúc chuẩn từ profile.jsp của nhóm) */
        .profile-wrapper { display: flex; align-items: flex-start; min-height: 100vh; }
        .sidebar-menu { width: 280px; background-color: #000000; color: #ffffff; padding: 30px 0; position: sticky; top: 0; height: 100vh; overflow-y: auto; z-index: 1000; }
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

        /* Lux Card thống nhất thiết kế */
        .lux-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            overflow: hidden;
            margin-bottom: 30px;
            border: 1px solid #eeeeee;
        }
        .lux-card-header {
            background-color: #000000;
            color: #ffffff;
            padding: 15px 25px;
        }
        .lux-card-header h3 { font-size: 18px; font-weight: 600; margin: 0; display: flex; align-items: center; gap: 10px; }
        .lux-card-body { padding: 25px; }

        /* Khung hiển thị chuỗi mã mã hóa */
        .key-textarea {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            font-family: 'Courier New', Courier, monospace;
            font-size: 13px;
            color: #212529;
            resize: none;
            padding: 12px;
        }
        .key-textarea:focus { border-color: #000000; box-shadow: none; outline: none; }

        .lux-label { font-size: 12px; font-weight: 600; color: #6c757d; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; display: flex; align-items: center; gap: 6px; }

        /* Nút bấm LUXCAR */
        .btn-lux-dark { padding: 10px 25px; background-color: #000000; color: #ffffff; border: 2px solid #000000; border-radius: 8px; font-weight: 500; transition: all 0.3s; display: inline-flex; align-items: center; justify-content: center; cursor: pointer; }
        .btn-lux-dark:hover { background-color: #ffffff; color: #000000; }
        .btn-lux-outline { padding: 10px 25px; background-color: #ffffff; color: #000000; border: 2px solid #000000; border-radius: 8px; font-weight: 500; transition: all 0.3s; display: inline-flex; align-items: center; justify-content: center; cursor: pointer; }
        .btn-lux-outline:hover { background-color: #000000; color: #ffffff; }
        .btn-lux-danger { padding: 10px 25px; background-color: #dc3545; color: #ffffff; border: 2px solid #dc3545; border-radius: 8px; font-weight: 500; transition: all 0.3s; display: inline-flex; align-items: center; justify-content: center; cursor: pointer; }
        .btn-lux-danger:hover { background-color: #ffffff; color: #dc3545; }

        .lux-badge-success { background-color: #e7f3e8; color: #2e7d32; border: 1px solid #c8e6c9; padding: 6px 14px; border-radius: 20px; font-size: 13px; display: inline-flex; align-items: center; gap: 6px; }

        /* Ẩn input file gốc để làm nút bấm đẹp */
        .custom-file-upload { display: inline-block; width: 100%; }
        .custom-file-upload input[type="file"] { display: none; }

        @media (max-width: 768px) { .sidebar-menu { display: none; } }
    </style>
</head>
<body>

<div class="profile-wrapper">
    <div class="sidebar-menu">
        <div class="menu-items">
            <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                <i class="fas fa-chart-pie"></i><span>Bảng điều khiển</span>
            </a>
            <a href="${pageContext.request.contextPath}/profile" class="menu-item">
                <i class="fas fa-user-circle"></i><span>Thông tin cá nhân</span>
            </a>
            <a href="${pageContext.request.contextPath}/key-manager" class="menu-item active">
                <i class="fas fa-key"></i><span>Quản lý khóa bảo mật</span>
            </a>
            <a href="${pageContext.request.contextPath}/profileEdit" class="menu-item">
                <i class="fas fa-user-edit"></i><span>Chỉnh sửa thông tin</span>
            </a>
            <a href="${pageContext.request.contextPath}/changePassword" class="menu-item">
                <i class="fas fa-lock"></i><span>Đổi mật khẩu</span>
            </a>
            <a href="${pageContext.request.contextPath}/order" class="menu-item">
                <i class="fas fa-shopping-bag"></i><span>Đơn hàng của tôi</span>
            </a>
            <a href="${pageContext.request.contextPath}/cart" class="menu-item">
                <i class="fas fa-shopping-cart"></i><span>Giỏ hàng</span>
            </a>
            <a href="${pageContext.request.contextPath}/favorites" class="menu-item">
                <i class="fas fa-heart"></i><span>Sản phẩm yêu thích</span>
            </a>
            <div class="menu-divider"></div>
            <a href="${pageContext.request.contextPath}/loggout" class="menu-item">
                <i class="fas fa-sign-out-alt"></i><span>Đăng xuất</span>
            </a>
        </div>
    </div>

    <div class="main-content">
        <div class="content-header">
            <h1>Quản Lý Khóa &amp; Bảo Mật Hệ Thống</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/profile">Tài khoản</a></li>
                    <li class="breadcrumb-item active">Quản lý khóa</li>
                </ol>
            </nav>
        </div>

        <div class="row g-4">

            <div class="col-lg-6">

                <div class="lux-card">
                    <div class="lux-card-header">
                        <h3><i class="fas fa-shield-alt"></i> 1. Khóa Công Khai (Public Key)</h3>
                    </div>
                    <div class="lux-card-body">
                        <form action="${pageContext.request.contextPath}/key-manager" method="POST">
                            <div class="mb-3">
                                <label class="lux-label"><i class="fas fa-code"></i> Chuỗi mã Public Key định dạng PEM</label>
                                <textarea name="publicKeyText" id="txtPublicKey" class="form-control key-textarea w-100" rows="5" readonly placeholder="Chưa có khóa. Hãy nhấn nút Tạo Khóa Mới bên dưới..."></textarea>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="button" id="btnTaoKhoa" class="btn btn-lux-outline flex-grow-1" onclick="xuLyGiaoDienTaoKhoaRSA()">
                                    <i class="fas fa-magic me-2"></i> Tạo Cặp Khóa Mới
                                </button>
                                <button type="submit" id="btnGuiServer" class="btn btn-lux-dark flex-grow-1" disabled>
                                    <i class="fas fa-cloud-arrow-up me-2"></i> Đồng Bộ Lên Server
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="lux-card" id="khuVucTaiKhoa" style="display: none;">
                    <div class="lux-card-body text-center py-4">
                        <div class="lux-badge-success mb-3">
                            <i class="fas fa-check-circle"></i> Đã tính toán xong cặp khóa RSA-2048
                        </div>
                        <p class="small text-muted mb-3">Vui lòng tải Private Key về máy tính cá nhân để lưu trữ bí mật.</p>
                        <button type="button" class="btn btn-lux-outline w-100" onclick="taiFilePrivateKeyXuongMayClient()">
                            <i class="fas fa-download me-2"></i> Tải Xuống Khóa Bí Mật (.PEM)
                        </button>
                    </div>
                </div>

                <div class="lux-card">
                    <div class="lux-card-header">
                        <h3><i class="fas fa-file-import"></i> 2. Nạp Khóa Bí Mật (Import Private Key)</h3>
                    </div>
                    <div class="lux-card-body">
                        <p class="small text-muted mb-3">Tải lại file khóa bí mật cũ của bạn hoặc dán văn bản để thực hiện giải mã cục bộ.</p>

                        <div class="mb-3">
                            <label class="custom-file-upload btn btn-lux-outline w-100 text-center">
                                <input type="file" id="fileKeyInput" accept=".pem,.txt" onchange="docVaImportFilePrivateKeyLocal(this)" />
                                <i class="fas fa-upload me-2"></i> Chọn tệp khóa từ thiết bị (.PEM)
                            </label>
                        </div>

                        <div>
                            <label class="lux-label"><i class="fas fa-key"></i> Hoặc dán trực tiếp mã Private Key vào ô dưới</label>
                            <textarea id="txtPrivateKeyArea" class="form-control key-textarea w-100" rows="4" placeholder="-----BEGIN RSA PRIVATE KEY-----&#10;... Dán chuỗi bí mật tại đây ..." oninput="capNhatBoNhoTamPrivateKey(this.value)"></textarea>
                        </div>
                    </div>
                </div>

                <div class="lux-card">
                    <div class="lux-card-header bg-dark text-white" style="background-color: #dc3545 !important;">
                        <h3><i class="fas fa-exclamation-triangle"></i> 3. Báo Cáo Sự Cố Lộ Khóa</h3>
                    </div>
                    <div class="lux-card-body">
                        <p class="small text-muted mb-3">Nếu bạn vô tình làm lộ file khóa bí mật, hãy nhấn báo cáo để hủy bỏ khóa công khai cũ trên Database.</p>
                        <form action="${pageContext.request.contextPath}/report-lost-key" method="POST" onsubmit="return xacNhanTruocKhiGuiBaoMat()">
                            <button type="submit" class="btn btn-lux-danger w-100">
                                <i class="fas fa-ban me-2"></i> Báo Mất / Vô Hiệu Hóa Khóa
                            </button>
                        </form>
                    </div>
                </div>

            </div>

            <div class="col-lg-6">
                <div class="lux-card">
                    <div class="lux-card-header">
                        <h3><i class="fas fa-lock"></i> Công Cụ Mã Hóa &amp; Giải Mã Dữ Liệu</h3>
                    </div>
                    <div class="lux-card-body">
                        <div class="mb-3">
                            <label class="lux-label" for="txtInputData"><i class="fas fa-arrow-right-to-bracket"></i> Dữ liệu văn bản đầu vào</label>
                            <textarea id="txtInputData" class="form-control key-textarea w-100" rows="5" placeholder="Nhập văn bản cần mã hóa hoặc dán chuỗi Base64 cần giải mã tại đây..."></textarea>
                        </div>

                        <div class="mb-4">
                            <div class="d-flex gap-3">
                                <button type="button" class="btn btn-lux-dark flex-grow-1" onclick="chayHàmMaHoaVoiPublicKey()">
                                    <i class="fas fa-file-shield me-2"></i> Mã Hóa (Public Key)
                                </button>
                                <button type="button" class="btn btn-lux-outline flex-grow-1" onclick="chayHamGiaiMaVoiPrivateKey()">
                                    <i class="fas fa-unlock-keyhole me-2"></i> Giải Mã (Private Key)
                                </button>
                            </div>
                        </div>

                        <div>
                            <label class="lux-label" for="txtOutputData"><i class="fas fa-arrow-right-from-bracket"></i> Kết quả xử lý đầu ra</label>
                            <textarea id="txtOutputData" class="form-control key-textarea w-100" rows="5" readonly placeholder="Kết quả chuỗi mã ký tự rác Base64 sẽ xuất hiện ở đây..."></textarea>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>

<script>
    var privateKeyLuuTam = "";
    var publicKeyLuuTam = "";

    // Sinh khóa RSA 2048-bit bằng forge.js
    function xuLyGiaoDienTaoKhoaRSA() {
        var btn = document.getElementById("btnTaoKhoa");
        btn.innerHTML = "<i class='fas fa-circle-notch fa-spin me-2'></i> Đang tính toán cặp khóa...";
        btn.disabled = true;

        forge.pki.rsa.generateKeyPair({bits: 2048, workers: 2}, function(err, keypair) {
            if (err) { alert("Lỗi: " + err); return; }

            publicKeyLuuTam = forge.pki.publicKeyToPem(keypair.publicKey);
            privateKeyLuuTam = forge.pki.privateKeyToPem(keypair.privateKey);

            document.getElementById("txtPublicKey").value = publicKeyLuuTam;
            document.getElementById("txtPrivateKeyArea").value = privateKeyLuuTam;

            document.getElementById("khuVucTaiKhoa").style.display = "block";
            document.getElementById("btnGuiServer").disabled = false; // Mở khóa nút submit form gửi lên Java Server

            btn.innerHTML = "<i class='fas fa-magic me-2'></i> Tạo Cặp Khóa Khác";
            btn.disabled = false;
        });
    }

    // Đọc file .pem từ thiết bị máy tính (Tính năng Import Key file)
    function docVaImportFilePrivateKeyLocal(input) {
        var file = input.files[0];
        if (!file) return;

        var reader = new FileReader();
        reader.onload = function(e) {
            var content = e.target.result;
            document.getElementById("txtPrivateKeyArea").value = content;
            privateKeyLuuTam = content; // Nạp vào biến để sẵn sàng giải mã
            alert("Đã Import file Private Key thành công! Hệ thống sẵn sàng giải mã.");
        };
        reader.readAsText(file);
    }

    function capNhatBoNhoTamPrivateKey(val) {
        privateKeyLuuTam = val;
    }

    function taiFilePrivateKeyXuongMayClient() {
        if (!privateKeyLuuTam) return;
        var blob = new Blob([privateKeyLuuTam], { type: "text/plain" });
        var theA = document.createElement("a");
        theA.href = window.URL.createObjectURL(blob);
        theA.download = "luxcar_private_key.pem";
        theA.click();
    }

    function xacNhanTruocKhiGuiBaoMat() {
        return confirm("Hệ thống LUXCAR cảnh báo: Bạn có chắc chắn muốn báo lộ/mất khóa? Yêu cầu sẽ gửi lên Server để vô hiệu hóa khóa cũ.");
    }

    function chayHàmMaHoaVoiPublicKey() {
        var plainText = document.getElementById("txtInputData").value;
        if (!plainText) { alert("Vui lòng điền văn bản cần mã hóa!"); return; }
        if (!publicKeyLuuTam) { publicKeyLuuTam = document.getElementById("txtPublicKey").value; }
        if (!publicKeyLuuTam) { alert("Yêu cầu cần có Public Key!"); return; }

        try {
            var publicKey = forge.pki.publicKeyFromPem(publicKeyLuuTam);
            var encrypted = publicKey.encrypt(plainText, 'RSA-OAEP');
            document.getElementById("txtOutputData").value = forge.util.encode64(encrypted);
        } catch (error) { alert("Mã hóa lỗi: " + error.message); }
    }

    function chayHamGiaiMaVoiPrivateKey() {
        var cipherTextBase64 = document.getElementById("txtInputData").value;
        if (!cipherTextBase64) { alert("Hãy dán chuỗi mật mã Base64 vào ô dữ liệu đầu vào!"); return; }
        if (!privateKeyLuuTam) { alert("Không tìm thấy Private Key! Hãy Import file khóa của bạn ở cột bên trái."); return; }

        try {
            var privateKey = forge.pki.privateKeyFromPem(privateKeyLuuTam);
            var encryptedBytes = forge.util.decode64(cipherTextBase64);
            document.getElementById("txtOutputData").value = privateKey.decrypt(encryptedBytes, 'RSA-OAEP');
        } catch (error) { alert("Giải mã thất bại! Khóa bí mật đã nạp không khớp với chuỗi mã hóa này."); }
    }
</script>

</body>
</html>