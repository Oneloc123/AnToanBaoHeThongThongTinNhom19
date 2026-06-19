package code.salecar.tool;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.datatransfer.StringSelection;
import java.io.File;
import java.nio.file.Files;
import java.security.*;
import java.util.Base64;

public class SigningToolFrame extends JFrame {

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (Exception ignored) {
            }
            new SigningToolFrame().setVisible(true);
        });
    }

    public SigningToolFrame() {
        setTitle("Công cụ Ký số Điện tử DSA - LUXCAR");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(750, 650);
        setLocationRelativeTo(null);
        setResizable(true);

        JTabbedPane tabbedPane = new JTabbedPane();
        tabbedPane.addTab("Quản lý Khóa", createKeyManagementPanel());
        tabbedPane.addTab("Ký Đơn Hàng", createOrderSigningPanel());

        tabbedPane.setFont(new Font("Segoe UI", Font.PLAIN, 14));

        add(tabbedPane);

        JMenuBar menuBar = new JMenuBar();
        JMenu helpMenu = new JMenu("Trợ giúp");
        JMenuItem aboutItem = new JMenuItem("Giới thiệu");
        aboutItem.addActionListener(e -> JOptionPane.showMessageDialog(this,
                "Công cụ Ký số Điện tử LUXCAR DSA v2.0\n\n" +
                        "1. Tạo cặp khóa DSA và lưu vào một thư mục (Tab 1)\n" +
                        "2. Copy nội dung file 'public_key.txt' cấu hình vào tài khoản LUXCAR của bạn\n" +
                        "3. Tại trang đơn hàng, copy chuỗi dữ liệu Hash đơn hàng (Order Hash Data)\n" +
                        "4. Chuyển sang Tab 2, chọn file chứa khóa bí mật 'private_key.txt'\n" +
                        "5. Dán chuỗi Hash dữ liệu, bấm 'Ký đơn hàng' và copy chữ ký số kết quả quay lại website.",
                "Giới thiệu",
                JOptionPane.INFORMATION_MESSAGE));
        helpMenu.add(aboutItem);
        menuBar.add(helpMenu);
        setJMenuBar(menuBar);
    }

    private JPanel createKeyManagementPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));


        JLabel infoLabel = new JLabel("Tạo cặp khóa DSA 2048-bit và lưu trực tiếp vào thư mục máy tính của bạn.");
        infoLabel.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        infoLabel.setBorder(new EmptyBorder(0, 0, 10, 0));

        JButton generateBtn = new JButton("Tạo & Lưu Cặp Khóa DSA (2048-bit)");
        generateBtn.setFont(new Font("Segoe UI", Font.BOLD, 13));
        generateBtn.setBackground(new Color(212, 175, 55));
        generateBtn.setForeground(Color.BLACK);
        generateBtn.setFocusPainted(false);


        JLabel pubLabel = new JLabel("Khóa công khai (Public Key - Nội dung được lưu vào file public_key.txt):");
        pubLabel.setFont(new Font("Segoe UI", Font.BOLD, 12));
        JTextArea pubKeyArea = new JTextArea();
        pubKeyArea.setEditable(false);
        pubKeyArea.setFont(new Font("Courier New", Font.PLAIN, 11));
        pubKeyArea.setLineWrap(true);
        pubKeyArea.setWrapStyleWord(true);
        JScrollPane pubScroll = new JScrollPane(pubKeyArea);
        pubScroll.setPreferredSize(new Dimension(680, 120));

        JButton copyPubBtn = new JButton("Sao chép Khóa Công Khai");
        copyPubBtn.setEnabled(false);
        JLabel privLabel = new JLabel("Khóa bí mật (Private Key - BẢO MẬT - Nội dung được lưu vào file private_key.txt):");
        privLabel.setFont(new Font("Segoe UI", Font.BOLD, 12));
        JTextArea privKeyArea = new JTextArea();
        privKeyArea.setEditable(false);
        privKeyArea.setFont(new Font("Courier New", Font.PLAIN, 11));
        privKeyArea.setLineWrap(true);
        privKeyArea.setWrapStyleWord(true);
        JScrollPane privScroll = new JScrollPane(privKeyArea);
        privScroll.setPreferredSize(new Dimension(680, 120));

        JButton copyPrivBtn = new JButton("Sao chép Khóa Bí Mật");
        copyPrivBtn.setEnabled(false);

        JLabel statusLabel = new JLabel(" ");
        statusLabel.setFont(new Font("Segoe UI", Font.ITALIC, 11));

        generateBtn.addActionListener(e -> {
            JFileChooser chooser = new JFileChooser();
            chooser.setDialogTitle("Chọn thư mục để lưu cặp khóa");
            chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
            chooser.setAcceptAllFileFilterUsed(false);

            if (chooser.showSaveDialog(this) == JFileChooser.APPROVE_OPTION) {
                File targetFolder = chooser.getSelectedFile();
                try {
                    statusLabel.setText("Đang khởi tạo cặp khóa DSA...");
                    generateBtn.setEnabled(false);

                    KeyPairGenerator keyGen = KeyPairGenerator.getInstance("DSA");
                    keyGen.initialize(2048, new SecureRandom());
                    KeyPair keyPair = keyGen.generateKeyPair();

                    String pubKeyStr = "<<BeginPublicKey>>\n" +
                            Base64.getEncoder().encodeToString(keyPair.getPublic().getEncoded()) +
                            "\n<<EndPublicKey>>";

                    String privKeyStr = "<<BeginPrivateKey>>\n" +
                            Base64.getEncoder().encodeToString(keyPair.getPrivate().getEncoded()) +
                            "\n<<EndPrivateKey>>";

                    File pubFile = new File(targetFolder, "public_key.txt");
                    File privFile = new File(targetFolder, "private_key.txt");

                    Files.write(pubFile.toPath(), pubKeyStr.getBytes("UTF-8"));
                    Files.write(privFile.toPath(), privKeyStr.getBytes("UTF-8"));

                    pubKeyArea.setText(pubKeyStr);
                    privKeyArea.setText(privKeyStr);

                    copyPubBtn.setEnabled(true);
                    copyPrivBtn.setEnabled(true);
                    statusLabel.setText("Đã lưu cặp khóa thành công tại: " + targetFolder.getAbsolutePath());
                    JOptionPane.showMessageDialog(this,
                            "Lưu cặp khóa thành công tại:\n" + pubFile.getAbsolutePath() + "\n" + privFile.getAbsolutePath(),
                            "Thành công", JOptionPane.INFORMATION_MESSAGE);
                    generateBtn.setEnabled(true);
                } catch (Exception ex) {
                    JOptionPane.showMessageDialog(this,
                            "Lỗi khi tạo hoặc lưu cặp khóa: " + ex.getMessage(),
                            "Lỗi hệ thống",
                            JOptionPane.ERROR_MESSAGE);
                    generateBtn.setEnabled(true);
                    statusLabel.setText("Quá trình tạo khóa thất bại!");
                }
            }
        });

        copyPubBtn.addActionListener(e -> {
            StringSelection selection = new StringSelection(pubKeyArea.getText());
            Toolkit.getDefaultToolkit().getSystemClipboard().setContents(selection, null);
            statusLabel.setText("Đã sao chép Khóa Công Khai vào bộ nhớ tạm!");
        });

        copyPrivBtn.addActionListener(e -> {
            StringSelection selection = new StringSelection(privKeyArea.getText());
            Toolkit.getDefaultToolkit().getSystemClipboard().setContents(selection, null);
            statusLabel.setText("Đã sao chép Khóa Bí Mật vào bộ nhớ tạm!");
        });

        JPanel topPanel = new JPanel(new BorderLayout());
        topPanel.add(infoLabel, BorderLayout.NORTH);
        topPanel.add(generateBtn, BorderLayout.CENTER);

        JPanel pubPanel = new JPanel(new BorderLayout(5, 5));
        pubPanel.add(pubLabel, BorderLayout.NORTH);
        pubPanel.add(pubScroll, BorderLayout.CENTER);
        pubPanel.add(copyPubBtn, BorderLayout.EAST);

        JPanel privPanel = new JPanel(new BorderLayout(5, 5));
        privPanel.add(privLabel, BorderLayout.NORTH);
        privPanel.add(privScroll, BorderLayout.CENTER);
        privPanel.add(copyPrivBtn, BorderLayout.EAST);

        JPanel centerPanel = new JPanel();
        centerPanel.setLayout(new BoxLayout(centerPanel, BoxLayout.Y_AXIS));
        centerPanel.add(topPanel);
        centerPanel.add(Box.createVerticalStrut(15));
        centerPanel.add(pubPanel);
        centerPanel.add(Box.createVerticalStrut(15));
        centerPanel.add(privPanel);
        centerPanel.add(Box.createVerticalStrut(10));
        centerPanel.add(statusLabel);

        panel.add(centerPanel, BorderLayout.CENTER);

        return panel;
    }

    private JPanel createOrderSigningPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        JLabel instrLabel = new JLabel(
                "<html><b>Bước 1:</b> Nhấp nút 'Chọn File...' để chọn file khóa bí mật 'private_key.txt'.<br>" +
                        "<b>Bước 2:</b> Dán chuỗi Dữ liệu Hash Đơn hàng sao chép từ hệ thống LUXCAR.<br>" +
                        "<b>Bước 3:</b> Bấm nút 'Ký Đơn Hàng' để tạo chữ ký số điện tử.</html>");
        instrLabel.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        instrLabel.setBorder(new EmptyBorder(0, 0, 10, 0));

        JLabel privLabel = new JLabel("Đường dẫn File Khóa Bí Mật (DSA Private Key File):");
        privLabel.setFont(new Font("Segoe UI", Font.BOLD, 12));
        JTextField privPathField = new JTextField();
        privPathField.setEditable(false);
        privPathField.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        JButton browsePrivBtn = new JButton("Chọn File...");

        final String[] privateKeyHolder = {""};

        browsePrivBtn.addActionListener(e -> {
            JFileChooser chooser = new JFileChooser();
            chooser.setDialogTitle("Chọn File Khóa Bí Mật (private_key.txt)");
            if (chooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
                File selectedFile = chooser.getSelectedFile();
                try {
                    String content = new String(Files.readAllBytes(selectedFile.toPath()), "UTF-8");
                    if (content.contains("<<BeginPrivateKey>>")) {
                        privateKeyHolder[0] = content;
                        privPathField.setText(selectedFile.getAbsolutePath());
                    } else {
                        JOptionPane.showMessageDialog(this, "Định dạng file khóa bí mật DSA không hợp lệ!", "Lỗi định dạng", JOptionPane.ERROR_MESSAGE);
                    }
                } catch (Exception ex) {
                    JOptionPane.showMessageDialog(this, "Không thể đọc file: " + ex.getMessage(), "Lỗi đọc File", JOptionPane.ERROR_MESSAGE);
                }
            }
        });

        JPanel privFilePanel = new JPanel(new BorderLayout(5, 5));
        privFilePanel.add(privPathField, BorderLayout.CENTER);
        privFilePanel.add(browsePrivBtn, BorderLayout.EAST);

        JLabel hashLabel = new JLabel("Dữ liệu Hash Đơn hàng (Order Hash Data từ LUXCAR):");
        hashLabel.setFont(new Font("Segoe UI", Font.BOLD, 12));
        JTextArea hashInput = new JTextArea();
        hashInput.setFont(new Font("Courier New", Font.PLAIN, 11));
        hashInput.setLineWrap(true);
        hashInput.setWrapStyleWord(true);
        JScrollPane hashScroll = new JScrollPane(hashInput);
        hashScroll.setPreferredSize(new Dimension(680, 80));

        JButton signBtn = new JButton("Ký Đơn Hàng");
        signBtn.setFont(new Font("Segoe UI", Font.BOLD, 14));
        signBtn.setBackground(new Color(212, 175, 55));
        signBtn.setForeground(Color.BLACK);
        signBtn.setFocusPainted(false);

        JLabel sigLabel = new JLabel("Chữ ký số kết quả (Hãy sao chép chuỗi này dán lại vào Website):");
        sigLabel.setFont(new Font("Segoe UI", Font.BOLD, 12));
        JTextArea sigOutput = new JTextArea();
        sigOutput.setEditable(false);
        sigOutput.setFont(new Font("Courier New", Font.PLAIN, 11));
        sigOutput.setLineWrap(true);
        sigOutput.setWrapStyleWord(true);
        JScrollPane sigScroll = new JScrollPane(sigOutput);
        sigScroll.setPreferredSize(new Dimension(680, 80));

        JButton copySigBtn = new JButton("Sao chép Chữ Ký");
        copySigBtn.setEnabled(false);

        JLabel statusLabel = new JLabel(" ");
        statusLabel.setFont(new Font("Segoe UI", Font.ITALIC, 11));

        signBtn.addActionListener(e -> {
            String privKeyStr = privateKeyHolder[0].trim();
            String hashData = hashInput.getText().trim();

            if (privKeyStr.isEmpty()) {
                JOptionPane.showMessageDialog(panel,
                        "Vui lòng chọn file Khóa Bí Mật trước khi thực hiện ký đơn!",
                        "Thiếu Khóa Bí Mật",
                        JOptionPane.WARNING_MESSAGE);
                return;
            }
            if (hashData.isEmpty()) {
                JOptionPane.showMessageDialog(panel,
                        "Vui lòng dán chuỗi Dữ liệu Hash Đơn hàng cần ký!",
                        "Thiếu Dữ Liệu Đơn Hàng",
                        JOptionPane.WARNING_MESSAGE);
                return;
            }

            try {
                statusLabel.setText("Đang thực hiện ký số điện tử...");
                signBtn.setEnabled(false);

                String cleaned = privKeyStr
                        .replace("<<BeginPrivateKey>>", "")
                        .replace("<<EndPrivateKey>>", "")
                        .replace("<<BeginPublicKey>>", "")
                        .replace("<<EndPublicKey>>", "")
                        .replaceAll("\\s", "");

                byte[] keyBytes = java.util.Base64.getDecoder().decode(cleaned);
                java.security.spec.PKCS8EncodedKeySpec spec =
                        new java.security.spec.PKCS8EncodedKeySpec(keyBytes);
                KeyFactory keyFactory = KeyFactory.getInstance("DSA");
                PrivateKey privateKey = keyFactory.generatePrivate(spec);
                Signature signature = Signature.getInstance("SHA256withDSA");
                signature.initSign(privateKey);
                signature.update(hashData.getBytes("UTF-8"));
                byte[] signatureBytes = signature.sign();
                String signatureBase64 = java.util.Base64.getEncoder().encodeToString(signatureBytes);

                sigOutput.setText(signatureBase64);
                copySigBtn.setEnabled(true);
                statusLabel.setText("Tạo chữ ký số điện tử thành công!");
                signBtn.setEnabled(true);

            } catch (Exception ex) {
                JOptionPane.showMessageDialog(panel,
                        "Lỗi trong quá trình ký số DSA: " + ex.getMessage(),
                        "Lỗi Ký Số",
                        JOptionPane.ERROR_MESSAGE);
                statusLabel.setText("Quá trình ký số thất bại!");
                signBtn.setEnabled(true);
            }
        });

        copySigBtn.addActionListener(e -> {
            StringSelection selection = new StringSelection(sigOutput.getText());
            Toolkit.getDefaultToolkit().getSystemClipboard().setContents(selection, null);
            statusLabel.setText("Đã sao chép Chữ ký số vào bộ nhớ tạm!");
        });

        JPanel centerPanel = new JPanel();
        centerPanel.setLayout(new BoxLayout(centerPanel, BoxLayout.Y_AXIS));
        centerPanel.add(instrLabel);
        centerPanel.add(privLabel);
        centerPanel.add(Box.createVerticalStrut(5));
        centerPanel.add(privFilePanel);
        centerPanel.add(Box.createVerticalStrut(10));
        centerPanel.add(hashLabel);
        centerPanel.add(Box.createVerticalStrut(5));
        centerPanel.add(hashScroll);
        centerPanel.add(Box.createVerticalStrut(15));

        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        btnPanel.add(signBtn);
        centerPanel.add(btnPanel);

        centerPanel.add(Box.createVerticalStrut(15));
        centerPanel.add(sigLabel);
        centerPanel.add(Box.createVerticalStrut(5));
        centerPanel.add(sigScroll);
        centerPanel.add(Box.createVerticalStrut(5));

        JPanel copyPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        copyPanel.add(copySigBtn);
        centerPanel.add(copyPanel);

        centerPanel.add(Box.createVerticalStrut(5));
        centerPanel.add(statusLabel);

        panel.add(centerPanel, BorderLayout.CENTER);

        return panel;
    }
}