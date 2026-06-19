package code.salecar.controller.profile;

import code.salecar.dao.DigitalKeyDAO;
import code.salecar.model.KeyManament.DigitalKey;
import code.salecar.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DigitalKeyController", value = "/digital-keys")
public class DigitalKeyController extends HttpServlet {

    private final DigitalKeyDAO keyDAO = new DigitalKeyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if ("history".equals(action)) {
            List<DigitalKey> keys = keyDAO.getKeysByUserId(user.getId());
            request.setAttribute("keyHistory", keys);
        }

        DigitalKey activeKey = keyDAO.getActiveKeyByUserId(user.getId());
        request.setAttribute("activeKey", activeKey);

        List<DigitalKey> keyHistory = keyDAO.getKeysByUserId(user.getId());
        request.setAttribute("keyHistory", keyHistory);

        request.getRequestDispatcher("/pages/digital-keys.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            String publicKey = request.getParameter("publicKey");
            if (publicKey == null || publicKey.trim().isEmpty()) {
                request.getSession().setAttribute("toastMessage", "Public key cannot be empty!");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect("digital-keys");
                return;
            }

            if (!publicKey.contains("<<BeginPublicKey>>") || !publicKey.contains("<<EndPublicKey>>")) {
                request.getSession().setAttribute("toastMessage",
                        "Invalid key format! Must include <<BeginPublicKey>> and <<EndPublicKey>> boundaries.");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect("digital-keys");
                return;
            }

            if (keyDAO.hasActiveKey(user.getId())) {
                request.getSession().setAttribute("toastMessage",
                        "You already have an active key! Revoke it first before updating.");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect("digital-keys");
                return;
            }

            DigitalKey key = new DigitalKey();
            key.setUserId(user.getId());
            key.setPublicKey(publicKey.trim());

            int keyId = keyDAO.insertKey(key);
            if (keyId > 0) {
                request.getSession().setAttribute("toastMessage", "Public key saved successfully!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to save key. Please try again.");
                request.getSession().setAttribute("toastType", "error");
            }

            response.sendRedirect("digital-keys");

        } else if ("revoke".equals(action)) {

            boolean revoked = keyDAO.revokeActiveKey(user.getId());
            if (revoked) {
                request.getSession().setAttribute("toastMessage", "Key revoked successfully!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "No active key to revoke.");
                request.getSession().setAttribute("toastType", "error");
            }
            response.sendRedirect("digital-keys");

        } else {
            response.sendRedirect("digital-keys");
        }
    }
}
