<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="<c:out value='${product.description}' default='Thông tin chi tiết sản phẩm' />">
    <title><c:out value="${product.title}" default="Chi tiết sản phẩm" /> - MANGAZ</title>

    <!-- Font Awesome 6 Free CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TrangChiTiet.css">
</head>
<body>

<header class="bg-white border-b border-gray-200 py-4 px-6 md:px-12 flex items-center justify-between sticky top-0 z-50">
    <!-- Khu vực Logo -->
    <a href="${pageContext.request.contextPath}/" class="flex items-center gap-3 no-underline">
        <div class="bg-orange-300 p-2 rounded-lg">
            <i class="fas fa-book text-gray-800 text-xl"></i>
        </div>
        <div>
            <h1 class="text-xl font-extrabold text-orange-400 m-0 leading-none">MANGAZ</h1>
            <span class="text-[0.65rem] font-bold text-gray-400 uppercase tracking-wider">Collector Exchange</span>
        </div>
    </a>

    <!-- Thanh tìm kiếm -->
    <div class="hidden md:flex flex-1 max-w-xl mx-8 relative">
        <div class="absolute inset-y-0 left-0 flex items-center pl-4 pointer-events-none">
            <i class="fas fa-search text-gray-400"></i>
        </div>
        <input type="text" class="w-full bg-indigo-50/50 border border-indigo-100 text-gray-900 text-sm rounded-full focus:ring-indigo-500 focus:border-indigo-500 block pl-10 p-2.5 placeholder-gray-400 font-medium" placeholder="Tìm kiếm truyện, bài đăng và users">
    </div>

    <!-- Menu Điều hướng & Nút Đăng bài -->
    <nav class="hidden lg:flex items-center gap-6">
        <a href="#" class="text-indigo-600 font-bold text-sm border-b-2 border-indigo-600 pb-1 no-underline">Trang chủ</a>
        <a href="#" class="text-gray-700 font-bold text-sm hover:text-indigo-600 flex items-center gap-1 no-underline">
            Khám phá <i class="fas fa-chevron-down text-[0.6rem] text-gray-400"></i>
        </a>
        <a href="#" class="text-gray-700 font-bold text-sm hover:text-indigo-600 flex items-center gap-1 no-underline">
            <span class="w-2 h-2 rounded-full bg-indigo-600 inline-block"></span> Đấu giá
        </a>
        <a href="#" class="text-gray-700 font-bold text-sm hover:text-indigo-600 no-underline">Cộng đồng</a>

        <!-- Nút Đăng bài / Trade -->
        <a href="${pageContext.request.contextPath}/seller-manage" class="bg-emerald-500 hover:bg-emerald-600 text-white font-bold text-sm px-5 py-2.5 rounded-full flex items-center gap-2 transition-colors no-underline">
            <i class="fas fa-plus-circle"></i> Đăng bài / Trade
        </a>
    </nav>

    <!-- Khu vực Icons & Profile -->
    <div class="flex items-center gap-5 ml-6">
        <a href="#" class="text-gray-600 hover:text-indigo-600 relative transition-colors no-underline">
            <i class="far fa-heart text-xl"></i>
            <span class="absolute -top-1 -right-2 bg-indigo-600 text-white text-[0.6rem] font-bold px-1.5 py-0.5 rounded-full border-2 border-white">3</span>
        </a>
        <a href="#" class="text-gray-600 hover:text-indigo-600 relative transition-colors no-underline">
            <i class="fas fa-shopping-cart text-xl"></i>
            <span class="absolute -top-1 -right-2 bg-indigo-600 text-white text-[0.6rem] font-bold px-1.5 py-0.5 rounded-full border-2 border-white">1</span>
        </a>
        <a href="#" class="text-gray-600 hover:text-indigo-600 relative transition-colors no-underline mr-2">
            <i class="far fa-bell text-xl"></i>
            <span class="absolute top-0 right-0 w-2.5 h-2.5 bg-indigo-600 border-2 border-white rounded-full"></span>
        </a>

        <div class="border-l pl-4 border-gray-200 relative group">
            <c:choose>
                <%-- NẾU ĐÃ ĐĂNG NHẬP --%>
                <c:when test="${not empty sessionScope.account}">
                    <div class="flex items-center gap-2 cursor-pointer">
                        <div class="relative">
                                <%-- Lấy 2 chữ cái đầu của tên (Ví dụ: "Nguyen" -> "NG", "User" -> "US") --%>
                            <div class="w-10 h-10 rounded-full bg-indigo-900 text-white flex items-center justify-center font-bold text-sm border-2 border-gray-100">
                                    ${fn:substring(fn:toUpperCase(sessionScope.account.username), 0, 2)}
                            </div>
                            <div class="absolute -bottom-1 -right-1 bg-yellow-400 text-gray-900 rounded-full p-1 border-2 border-white flex items-center justify-center w-5 h-5">
                                <i class="fas fa-cog text-[0.5rem]"></i>
                            </div>
                        </div>
                        <i class="fas fa-chevron-down text-gray-400 text-xs transition-transform group-hover:rotate-180"></i>
                    </div>

                    <%-- Dropdown Menu (Sẽ hiện khi hover vào khối user) --%>
                    <div class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 hidden group-hover:block border border-gray-100">
                        <div class="px-4 py-2 border-b border-gray-100">
                            <p class="text-sm font-bold text-gray-900 truncate">${sessionScope.account.username}</p>
                            <p class="text-xs text-gray-500 truncate">${sessionScope.account.email}</p>
                        </div>
                        <a href="profile" class="block px-4 py-2 text-sm text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 no-underline"><i class="fas fa-user mr-2"></i>Tài khoản của tôi</a>
                        <a href="logout" class="block px-4 py-2 text-sm text-red-600 hover:bg-red-50 font-semibold no-underline"><i class="fas fa-sign-out-alt mr-2"></i>Đăng xuất</a>
                    </div>
                </c:when>

                <%-- NẾU CHƯA ĐĂNG NHẬP --%>
                <c:otherwise>
                    <a href="login" class="flex items-center gap-2 cursor-pointer text-gray-600 hover:text-indigo-600 no-underline">
                        <i class="fas fa-user-circle text-2xl"></i>
                        <span class="text-sm font-bold">Đăng nhập</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- NỘI DUNG TRANG CHI TIẾT SẢN PHẨM -->
<div class="background">
    <nav class="top-utility" aria-label="Điều hướng đường dẫn">
        <div class="container-wrapper">
            <div class="container">
                <ol class="div" aria-label="Breadcrumb">
                    <li class="div-2">
                        <a class="div-3" href="${pageContext.request.contextPath}/" aria-label="Trang chủ">
                            <span class="text">Trang chủ</span>
                        </a>
                    </li>
                    <li class="div-3" aria-hidden="true"><span class="text-wrapper">/</span></li>
                    <li class="div-3"><a class="text" href="${pageContext.request.contextPath}/chi-tiet-san-pham">Sản phẩm</a></li>
                    <li class="div-3" aria-hidden="true"><span class="text-wrapper">/</span></li>
                    <li class="div-3" aria-current="page">
                        <span class="p"><c:out value="${product.title}" default="Chi tiết sản phẩm" /></span>
                    </li>
                </ol>
            </div>
        </div>
    </nav>
    <main>
        <div class="div-wrapper">
            <div class="primary-showcase">
                <section class="left-column-gallery" aria-label="Hình ảnh sản phẩm">
                    <div class="main-visual-stage">
                        <div class="interactive-aspect" role="img" aria-label="Hình ảnh sản phẩm">
                            <!-- Xử lý nạp ảnh tự động từ Database hoặc fallback sang ảnh mặc định -->
                            <c:set var="productImg" value="${not empty product.imageUrl ? (product.imageUrl.startsWith('http') ? product.imageUrl : (product.imageUrl.startsWith('./') ? pageContext.request.contextPath.concat('/').concat(product.imageUrl.substring(2)) : pageContext.request.contextPath.concat('/').concat(product.imageUrl))) : pageContext.request.contextPath.concat('/Image/manga_01.jpg')}" />
                            <div class="div-4" style="background-image: url('${productImg}');"></div>
                            <div class="high-precision">
                                <div class="div-3"><i class="fa-solid fa-magnifying-glass-plus img-zoom"></i></div>
                                <p class="text-5">Hover để soi chi tiết x60</p>
                            </div>
                        </div>
                    </div>
                    <div class="div-7" role="group" aria-label="Các góc chụp sản phẩm">
                        <button class="button" type="button" aria-label="Xem bìa trước">
                            <div class="margin-2"><div class="div-wrapper-2"><div class="abaxubynucrvp" style="background-image: url('${productImg}');"></div></div></div>
                            <div class="container-2"><span class="text-8">Bìa trước</span></div>
                        </button>
                        <button class="button" type="button" aria-label="Xem bìa sau">
                            <div class="margin-2"><div class="div-wrapper-2"><div class="div-8" style="background-image: url('${productImg}');"></div></div></div>
                            <div class="container-3"><span class="text-8">Bìa sau</span></div>
                        </button>
                        <button class="button" type="button" aria-label="Xem gáy sách">
                            <div class="margin-2"><div class="div-wrapper-2"><div class="div-9" style="background-image: url('${productImg}');"></div></div></div>
                            <div class="container-2"><span class="text-8">Góc cạnh</span></div>
                        </button>
                        <button class="button" type="button" aria-label="Xem mặt tem">
                            <div class="margin-2"><div class="div-wrapper-2"><div class="div-10" style="background-image: url('${productImg}');"></div></div></div>
                            <div class="container-3"><span class="text-8">Mặt tem</span></div>
                        </button>
                    </div>
                </section>
                <section class="right-column" aria-labelledby="product-title">
                    <header class="manga-title-series">
                        <div class="container-4">
                            <div class="text-wrapper-2"><span class="text-12">CHÍNH HÃNG</span></div>
                            <div class="div-3"><p class="text">Mã SP: #00<c:out value="${product.id}" default="1" /></p></div>
                        </div>
                        <div class="heading">
                            <h1 class="one-piece-t-p-b-a" id="product-title">
                                <c:out value="${product.title}" default="Chi tiết sản phẩm" />
                            </h1>
                        </div>
                        <div class="div-wrapper-3">
                            <p class="t-c-ph-m-kinh-i-n-c">
                                <c:out value="${product.description}" default="Chưa có thông tin mô tả chi tiết cho sản phẩm này." />
                            </p>
                        </div>
                    </header>
                    <section class="condition-provenance" aria-label="Tình trạng và nguồn gốc">
                        <div class="container-4">
                            <div class="div-3"><i class="fa-solid fa-certificate icon-check-cert"></i></div>
                            <div class="div-3"><p class="text-13">Tình trạng: Mới 100% • Hàng chính hãng nguyên seal</p></div>
                        </div>
                        <div class="container-5">
                            <div class="background-shadow-4"><div class="div-13"></div><p class="text-5">Đảm bảo chất lượng</p></div>
                            <div class="background-shadow-5"><div class="div-14"></div><p class="text-5">Đóng gói chuẩn quy cách</p></div>
                            <div class="background-shadow-6"><div class="div-15"></div><p class="text-5">Hỗ trợ đổi trả 1-1</p></div>
                        </div>
                    </section>
                    <section class="seller-dossier-box" aria-label="Thông tin người bán">
                        <div class="container-6">
                            <div class="div">
                                <div class="div-wrapper-4"><div class="div-16" style="background-image: url('${productImg}');"></div></div>
                                <div class="div-3">
                                    <div class="container-7">
                                        <div class="div-3"><span class="text-wrapper-3"><c:out value="${not empty product.sellerName ? product.sellerName : 'MangaVault Shop'}" /></span></div>
                                        <div class="div-3"><i class="fa-solid fa-circle-check icon-seller-verified"></i></div>
                                    </div>
                                    <div class="container-8">
                                        <div class="container-9">
                                            <div class="div-3"><i class="fa-solid fa-star icon-rating-star"></i></div>
                                            <span class="text-14">5.0/5</span>
                                        </div>
                                        <div class="div-3"><span class="text">•</span></div>
                                        <div class="div-3"><p class="text">Đối tác xác thực</p></div>
                                    </div>
                                </div>
                            </div>
                            <div class="container-10"><div class="div-17"><div class="div-13"></div><span class="text-15">&lt; 15 phút</span></div></div>
                        </div>
                        <div class="container-11">
                            <a class="link" href="#">
                                <div class="div-3"><i class="fa-solid fa-store icon-action"></i></div>
                                <span class="text-9">Xem Shop</span>
                            </a>
                            <button class="button-3" type="button">
                                <span class="icon-wrapper"><i class="fa-solid fa-comment-dots icon-action"></i></span>
                                <span class="text-9">Nhắn tin riêng</span>
                            </button>
                        </div>
                    </section>
                    <section class="pricing-core-escrow" aria-label="Giá và mua hàng">
                        <div class="container-12">
                            <p class="text-2">GIÁ NIÊM YẾT CÔNG KHAI</p>
                            <div class="container-13">
                                <div class="paragraph">
                                    <span class="text-16">
                                        <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" />
                                    </span>
                                    <span class="text-17">đ</span>
                                </div>
                            </div>
                            <div class="container-15">
                                <div class="div-3"><i class="fa-solid fa-shield-halved icon-labs"></i></div>
                                <div class="div-3"><p class="text">Đã hoàn tất giám định và bảo chứng bởi Sàn</p></div>
                            </div>
                        </div>
                        <div class="purchase-cart-action">
                            <div class="div-7">
                                <button class="button-4" type="button">
                                    <div class="button-shadow"></div>
                                    <span class="icon-wrapper"><i class="fa-solid fa-bag-shopping icon-btn-buy"></i></span>
                                    <span class="text-wrapper-5">Mua ngay</span>
                                </button>
                                <button class="button-5" type="button" aria-label="Thêm sản phẩm vào giỏ hàng">
                                    <span class="icon-wrapper"><i class="fa-solid fa-cart-plus icon-btn-cart"></i></span>
                                </button>
                            </div>
                            <div class="trade-availability">
                                <div class="img-wrapper"><i class="fa-solid fa-truck-fast icon-trade"></i></div>
                                <div class="container-16">
                                    <p class="text-20">
                                        <span class="span">Giao hàng hỏa tốc:</span>
                                        <span class="text-wrapper-6">Hỗ trợ giao hàng tiêu chuẩn trong 24h - 48h trên toàn quốc.</span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </section>
                </section>
            </div>
        </div>

        <!-- Khối Giới Thiệu Sản Phẩm -->
        <div class="div-wrapper">
            <section class="product-intro-section" aria-labelledby="product-intro-title">
                <div class="intro-badge">
                    <span>GIỚI THIỆU SẢN PHẨM</span>
                </div>
                <h2 class="intro-title" id="product-intro-title">
                    <c:out value="${product.title}" default="Thông tin chi tiết" />
                </h2>
                <div class="intro-content">
                    <p>
                        <c:out value="${product.description}" default="Chưa có nội dung mô tả chi tiết cho sản phẩm này." />
                    </p>
                </div>
            </section>
        </div>
    </main>
</div>
<footer class="bg-white pt-16 pb-8 px-6 md:px-12 border-t border-gray-200 mt-12 font-sans">
    <div class="container mx-auto max-w-7xl">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-8 mb-12">
            <!-- Cột 1: Brand Info -->
            <div class="lg:col-span-1">
                <h3 class="text-xl font-bold text-indigo-600 mb-4">MangaVault</h3>
                <p class="text-sm text-gray-500 mb-6 leading-relaxed">
                    Sàn giao dịch truyện tranh, ấn bản hiếm & vật phẩm sưu tầm xác thực bản quyền số 1 tại Đông Nam Á.
                </p>
                <div class="inline-flex items-center gap-2 bg-indigo-50 text-indigo-700 text-xs font-bold px-3 py-1.5 rounded-full border border-indigo-100">
                    <i class="fas fa-shield-check"></i> 100% Bảo Chứng Escrow
                </div>
            </div>

            <!-- Cột 2: Danh Mục -->
            <div>
                <h4 class="text-xs font-bold text-gray-900 uppercase tracking-wider mb-5">DANH MỤC LƯU TRỮ</h4>
                <ul class="space-y-3 text-sm text-gray-500">
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Shonen Originals</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Seinen Masterpieces</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Shojo Vintage Classics</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Tankōbon First Editions</a></li>
                </ul>
            </div>

            <!-- Cột 3: Dịch vụ -->
            <div>
                <h4 class="text-xs font-bold text-gray-900 uppercase tracking-wider mb-5">DỊCH VỤ COLLECTOR</h4>
                <ul class="space-y-3 text-sm text-gray-500">
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Đấu Giá Trực Tiếp</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Thẩm Định & Đóng Slab</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Lịch Private Drops</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Ký Quỹ Ví Vault</a></li>
                </ul>
            </div>

            <!-- Cột 4: Pháp lý -->
            <div>
                <h4 class="text-xs font-bold text-gray-900 uppercase tracking-wider mb-5">KÝ QUỸ & PHÁP LÝ</h4>
                <ul class="space-y-3 text-sm text-gray-500">
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Bảo Hiểm Ký Quỹ Escrow</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Quy Trình Giám Định CGC/CBCS</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Chính Sách Hoàn Tiền 100%</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Điều Khoản Sử Dụng Sàn</a></li>
                </ul>
            </div>

            <!-- Cột 5: Hỗ trợ -->
            <div>
                <h4 class="text-xs font-bold text-gray-900 uppercase tracking-wider mb-5">TRUNG TÂM HỖ TRỢ</h4>
                <ul class="space-y-3 text-sm text-gray-500">
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Yêu Cầu Hỗ Trợ 24/7</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Quy Chuẩn Đóng Gói Manga</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Tra Cứu Mã Chứng Thư (API)</a></li>
                    <li><a href="#" class="hover:text-indigo-600 transition-colors">Quan Hệ Đối Tác & NXB</a></li>
                </ul>
            </div>
        </div>

        <!-- Footer Bottom -->
        <div class="pt-8 border-t border-gray-200 flex flex-col md:flex-row justify-between items-center gap-4 text-xs text-gray-500 font-medium">
            <div>
                © 2025 MangaZ Exchange Inc. Mọi quyền được bảo lưu.
            </div>
            <div class="flex items-center gap-4">
                <span>Bảo mật dữ liệu ISO 27001</span>
                <span class="w-1 h-1 rounded-full bg-gray-400"></span>
                <span>Chứng thực chữ ký số SHA-256</span>
            </div>
        </div>
    </div>
</footer>
</body>
</html>