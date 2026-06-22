package code.salecar.controller.checkout;

import code.salecar.model.Cart;
import code.salecar.model.CartItem;
import code.salecar.model.Order;
import code.salecar.model.User;
import code.salecar.model.product.dto.ProductItemDTO;
import code.salecar.service.order.OrderService;
import code.salecar.service.product.ProductService;
import code.salecar.service.product.VoucherService;
import code.salecar.service.buyNCart.VNPayService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "ProcessCheckout", value = "/process-checkout")
public class ProcessCheckout extends HttpServlet {

    private final VoucherService voucherService = new VoucherService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String type = request.getParameter("type");
        Cart targetCart = null;

        if("buynow".equals(type)){
            targetCart = (Cart) session.getAttribute("buyNowCart");
        } else {
            targetCart = (Cart) session.getAttribute("cart");
        }

        if (targetCart == null || targetCart.getItems().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        String name = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        String note = request.getParameter("note");
        String shippingMethod = request.getParameter("shippingMethod");

        double shippingFee = 0;
        String shippingFeeStr = request.getParameter("shippingFee");
        if (shippingFeeStr != null && !shippingFeeStr.isEmpty()) {
            try {
                shippingFee = Double.parseDouble(shippingFeeStr);
            } catch (NumberFormatException e) {
                shippingFee = 0;
            }
        }

        OrderService orderService = new OrderService();


        Order newOrder = null;
        try {
            newOrder = orderService.processOrder(user, targetCart, name, phone, shippingAddress, paymentMethod, shippingFee, note, shippingMethod);
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('Lỗi hệ thống: Không thể xử lý đơn hàng. Vui lòng thử lại sau!'); window.location.href='checkout';</script>");
            return;
        }

        if (newOrder != null && newOrder.getId() > 0) {

            Long selectedVoucherId = (Long) session.getAttribute("selectedVoucherId");

            if ("VNPAY".equals(paymentMethod)) {

                if ("buynow".equals(type)) {
                    session.setAttribute("pendingCartBackup", session.getAttribute("buyNowCart"));
                } else {
                    session.setAttribute("pendingCartBackup", session.getAttribute("cart"));
                }

                if (selectedVoucherId != null) {
                    session.setAttribute("pendingVoucherId", selectedVoucherId);
                }

                VNPayService vnPayService = new VNPayService();
                String paymentUrl = vnPayService.createPaymentUrl(request, newOrder);
                response.sendRedirect(paymentUrl);
            } else {

                if (selectedVoucherId != null) {
                    voucherService.incrementUsedCount(selectedVoucherId);
                }
                session.removeAttribute("selectedVoucherId");

                if ("buynow".equals(type)) {
                    session.removeAttribute("buyNowCart");
                } else {
                    session.removeAttribute("cart");
                }


                session.setAttribute("lastOrderId", newOrder.getId());


                try {
                    ProductService productService = new ProductService();
                    List<Long> categoryIds = new ArrayList<>();
                    List<Integer> excludeProductIds = new ArrayList<>();
                    Set<Long> seenCategories = new HashSet<>();

                    for (CartItem item : targetCart.getItems()) {
                        if (item.getProductDetail() != null
                                && item.getProductDetail().getCategory() != null
                                && seenCategories.add(item.getProductDetail().getCategory().getCategoryId())) {
                            categoryIds.add(item.getProductDetail().getCategory().getCategoryId());
                        }
                        excludeProductIds.add(item.getProductId());
                    }

                    List<ProductItemDTO> suggestedProducts = productService.getSuggestedProducts(categoryIds, excludeProductIds);
                    session.setAttribute("suggestedProducts", suggestedProducts);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                response.sendRedirect(request.getContextPath() + "/order-detail?id=" + newOrder.getId());
            }

        } else {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("Hệ thống quá tải hoặc có lỗi xảy ra. Vui lòng thử lại!");
        }
    }
}