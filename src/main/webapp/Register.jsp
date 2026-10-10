<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng ký | MangaZ</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@800;900&family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Space+Grotesk:wght@700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Css/Login.css">
</head>
<body>
<div class="mangaz-wrapper">
    <%@ include file="includes/header.jsp" %>

    <main class="mangaz-container">
        <%@ include file="includes/section.jsp" %>

        <div class="form-section">
            <div class="login-card">
                <h2 class="form-title">Đăng ký tài khoản</h2>
                <p class="form-subtitle">Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a></p>

                <c:if test="${not empty message || not empty sessionScope.message}">
                    <p style="color: #10b981; font-weight: 600; margin-bottom: 15px;">${not empty message ? message : sessionScope.message}</p>
                    <c:remove var="message" scope="session"/>
                </c:if>

                <c:if test="${not empty errorMessage || not empty sessionScope.errorMessage}">
                    <p style="color: #ef4444; font-weight: 600; margin-bottom: 15px;">${not empty errorMessage ? errorMessage : sessionScope.errorMessage}</p>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>
                <form class="login-form" action="${pageContext.request.contextPath}/register" method="post">

                    <div class="input-group">
                        <label for="input-fullname">HỌ VÀ TÊN</label>
                        <div class="input-wrapper">
                            <img src="Image/userNameLogo.svg" alt="user name" class="icon-left">
                            <input type="text" id="input-fullname" name="fullname" value="${fullname}" placeholder="Nguyễn Văn A" required>
                        </div>
                    </div>

                    <div class="input-group">
                        <label for="input-username">TÊN ĐĂNG NHẬP</label>
                        <div class="input-wrapper">
                            <img src="Image/userNameLogo.svg" alt="@" class="icon-left">
                            <input type="text" id="input-username" name="username" value="${username}" placeholder="otaku123" required>
                        </div>
                    </div>

                    <div class="input-group">
                        <label for="input-email">EMAIL</label>
                        <div class="input-wrapper">
                            <img src="Image/@.svg" alt="@" class="icon-left">
                            <input type="email" id="input-email" name="email" value="${email}" placeholder="otaku@mangaz.vn" required>
                        </div>
                    </div>


                    <div class="input-group">
                        <label for="input-password">MẬT KHẨU</label>
                        <div class="input-wrapper">
                            <img src="Image/pwLogo.svg" alt="Lock" class="icon-left">
                            <input type="password" id="input-password" name="password" placeholder="••••••••••••" required>
                            <button type="button" class="icon-right" id="toggle-pw" aria-label="Hiển thị mật khẩu">
                                <svg class="eye-icon eye-open" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#71717a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                <svg class="eye-icon eye-closed" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#71717a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
                            </button>
                        </div>
                    </div>
                    <div class="input-group">
                        <label for="input-confirm-password">XÁC NHẬN MẬT KHẨU</label>
                        <div class="input-wrapper">
                            <img src="Image/confirmPwLogo.svg" alt="@" class="icon-left">
                            <input type="password" id="input-confirm-password" name="confirm_password" placeholder="••••••••••••" required>
                            <button type="button" class="icon-right" id="toggle-confirm-pw" aria-label="Hiển thị mật khẩu">
                                <svg class="eye-icon eye-open" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#71717a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                <svg class="eye-icon eye-closed" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#71717a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
                            </button>
                        </div>
                    </div>

                    <label class="checkbox-container">
                        <input type="checkbox" name="terms" value="1" required>
                        <span class="checkmark"></span>
                        <span class="check-label">Tôi đồng ý với <a href="#" style="text-decoration: underline;">Điều khoản dịch vụ</a> và <a href="#" style="text-decoration: underline;">Chính sách bảo mật</a> của MangaZ.</span>
                    </label>

                    <button type="submit" class="btn-primary">
                        Tạo tài khoản MangaZ <img src="Image/turnRight.svg" alt="->" class="arrow-icon">
                    </button>
                </form>

                <div class="divider">
                    <span>HOẶC TIẾP TỤC VỚI</span>
                </div>

                <div class="social-login">
                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080${pageContext.request.contextPath}/google-login&response_type=code&client_id=918892325001-opqt9q70e7q7n0qstli2a3qqi8kb1rts.apps.googleusercontent.com&approval_prompt=force"
                       class="btn-social"
                       style="text-decoration: none; display: flex; align-items: center; justify-content: center;">
                        <img src="Image/googleLogo.svg" alt="G"> Tiếp tục với Google
                    </a>
                </div>

                <p class="terms-text">
                    Bằng việc tiếp tục, bạn đồng ý với <a href="/dieu-khoan">Điều khoản sử dụng</a> và <a href="/chinh-sach-bao-mat">Chính sách bảo mật</a> của MangaZ.
                </p>
            </div>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>
</div>

<script>
    document.querySelectorAll('.input-wrapper').forEach(wrapper => {
        const toggleBtn = wrapper.querySelector('button[id^="toggle-"]');
        const input = wrapper.querySelector('input');

        if (toggleBtn && input) {
            toggleBtn.addEventListener('click', () => {
                const isPassword = input.type === 'password';
                input.type = isPassword ? 'text' : 'password';

                wrapper.querySelector('.eye-open').style.display = isPassword ? 'none' : 'inline';
                wrapper.querySelector('.eye-closed').style.display = isPassword ? 'inline' : 'none';
            });
        }
    });
</script>
</body>
</html>