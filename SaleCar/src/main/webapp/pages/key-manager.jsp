<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Khóa Bảo Mật</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/forge/1.3.1/forge.min.js"></script>

    <style>
        /* Tùy chỉnh CSS cho thật đẹp và hiện đại */
        body {
            background-color: #f4f7f6;
        }
        .key-container {
            max-width: 900px;
            margin: 40px auto;
        }
        .custom-card {
            background: #fff;
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease;
            overflow: hidden;
        }
        .custom-card:hover {
            transform: translateY(-5px);
        }
        .card-header-gradient {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            color: white;
            padding: 20px;
            border-bottom: none;
        }
        .card-header-danger {
            background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
            color: white;
            padding: 20px;
        }
        .key-textarea {
            background-color: #f8f9fc;
            border: 2px dashed #d1d3e2;
            border-radius: 10px;
            font-family: 'Courier New', Courier, monospace;
            font-size: 13px;
            color: #5a5c69;
            resize: none;
        }
        .key-textarea:focus {
            border-color: #6a11cb;
            box-shadow: none;
        }
        .btn-custom {
            border-radius: 10px;
            padding: 12px 20px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.2s;
        }
        .btn-primary-custom {
            background-color: #4e73df;
            border: none;
            color: white;
        }
        .btn-primary-custom:hover {
            background-color: #2e59d9;
        }
    </style>
</head>
<body>

<div class="container key-container">
    <div class="row g-4">
        <div class="col-md-8">
            <div class="custom-card h-100">
                <div class="card-header-gradient">
                    <h4 class="mb-0"><i class="fas fa-shield-alt me-2"></i> Khóa Công Khai (Public Key)</h4>
                    <p class="mb-0 mt-1 small opacity-75">Khóa này sẽ được lưu trên Server để xác thực thông tin của bạn.</p>
                </div>
                <div class="card-body p-4">
                    <textarea id="txtPublicKey" class="form-control key-textarea mb-4" rows="10" readonly placeholder="Bạn chưa tạo khóa nào. Hãy nhấn nút tạo khóa bên dưới..."></textarea>

                    <button id="btnTaoKhoa" class="btn btn-custom btn-primary-custom w-100" onclick="taoKhoa()">
                        <i class="fas fa-magic me-2"></i> Tạo Cặp Khóa RSA Mới
                    </button>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="custom-card mb-4" id="khuVucTaiKhoa" style="display: none;">
                <div class="card-body p-4 text-center">
                    <div class="mb-3 text-success">
                        <i class="fas fa-check-circle fa-3x"></i>
                    </div>
                    <h5 class="fw-bold">Tạo Khóa Thành Công</h5>
                    <p class="small text-muted">Vui lòng tải Private Key về máy. Server không lưu giữ khóa này của bạn.</p>
                    <button class="btn btn-custom btn-outline-success w-100" onclick="taiPrivateKey()">
                        <i class="fas fa-download me-2"></i> Tải Private Key
                    </button>
                </div>
            </div>

            <div class="custom-card">
                <div class="card-header-danger">
                    <h5 class="mb-0"><i class="fas fa-exclamation-triangle me-2"></i> Báo Cáo Sự Cố</h5>
                </div>
                <div class="card-body p-4 text-center">
                    <p class="small text-muted mb-4">Nếu bạn vô tình làm lộ file Private Key, hãy báo cáo ngay để hệ thống vô hiệu hóa khóa cũ.</p>
                    <button class="btn btn-custom btn-danger w-100" onclick="baoMatKhoa()">
                        <i class="fas fa-ban me-2"></i> Báo Mất / Lộ Khóa
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    var privateKeyLuuTam = "";

    function taoKhoa() {
        var btn = document.getElementById("btnTaoKhoa");
        btn.innerHTML = "<i class='fas fa-spinner fa-spin me-2'></i> Đang tạo khóa...";
        btn.disabled = true;

        forge.pki.rsa.generateKeyPair({bits: 2048, workers: 2}, function(err, keypair) {
            if (err) {
                alert("Lỗi khi tạo khóa: " + err);
                return;
            }

            var publicKey = forge.pki.publicKeyToPem(keypair.publicKey);
            privateKeyLuuTam = forge.pki.privateKeyToPem(keypair.privateKey);

            document.getElementById("txtPublicKey").value = publicKey;

            document.getElementById("khuVucTaiKhoa").style.display = "block";

            btn.innerHTML = "<i class='fas fa-magic me-2'></i> Tạo Lại Khóa Khác";
            btn.disabled = false;

            console.log("Đã sẵn sàng gửi Public Key lên server:", publicKey);
        });
    }

    function taiPrivateKey() {
        if (privateKeyLuuTam === "") {
            alert("Chưa có khóa nào được tạo!");
            return;
        }

        var blob = new Blob([privateKeyLuuTam], { type: "text/plain" });
        var theA = document.createElement("a");
        theA.href = window.URL.createObjectURL(blob);
        theA.download = "khoa_bi_mat_cua_toi.pem";
        theA.click();
    }

    function baoMatKhoa() {
        var xacNhan = confirm("Bạn có chắc chắn muốn báo mất khóa? Hệ thống sẽ thu hồi khóa hiện tại của bạn.");

        if (xacNhan == true) {
            console.log("Gửi yêu cầu báo mất khóa lên server...");

            alert("Đã báo cáo lộ khóa thành công. Khóa cũ đã bị vô hiệu hóa.");

            document.getElementById("txtPublicKey").value = "--- KHÓA ĐÃ BỊ THU HỒI ---";
            document.getElementById("khuVucTaiKhoa").style.display = "none";
            privateKeyLuuTam = "";
        }
    }
</script>

</body>
</html>