package code.salecar.controller.order;

import code.salecar.dao.OrderDAO;
import code.salecar.model.Order;
import code.salecar.model.OrderItem;
import code.salecar.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "order-success", value = "/order-success")
public class OrderSuccessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/order");
            return;
        }

        try {
            int orderId = Integer.parseInt(idParam);
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);

            if (order == null || order.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/order");
                return;
            }

            List<OrderItem> items = orderDAO.getOrderItemsByOrderId(orderId);
            order.setItems(items);

            request.setAttribute("order", order);
            request.getRequestDispatcher("/pages/order-success.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/order");
        }
    }
}
