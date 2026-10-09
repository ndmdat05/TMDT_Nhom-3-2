
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="One Piece - Tập 1, bản in đầu 2003, tình trạng Like New 95%.">
    <title>One Piece - Tập 1 (Bản in đầu 2003)</title>

    <!-- Font Awesome 6 Free CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Css/TrangChiTiet.css">
</head>
<body>
<header class="header">
    <a class="container" href="${pageContext.request.contextPath}/" aria-label="MANGAZ - Trang chủ">
        <div class="background logo-badge">
            <i class="fa-solid fa-book-bookmark"></i>
        </div>
        <div class="div">
            <div class="div-wrapper">
                <span class="MAN-ga-z">MANGAZ</span>
            </div>
            <div class="div-wrapper">
                <span class="text">COLLECTOR EXCHANGE</span>
            </div>
        </div>
    </a>

    <form class="container-2" role="search" action="${pageContext.request.contextPath}/search" method="GET">
        <label class="input">
            <span class="div-wrapper">
                <input
                        class="text-wrapper"
                        type="search"
                        name="query"
                        placeholder="Tìm kiếm truyện, bài đăng và users"
                        aria-label="Tìm kiếm truyện, bài đăng và users"
                        autocomplete="off"
                >
            </span>
            <i class="fa-solid fa-magnifying-glass icon" aria-hidden="true"></i>
        </label>
    </form>

    <nav aria-label="Điều hướng chính">
        <a class="link" href="${pageContext.request.contextPath}/" aria-current="page">
            <span class="text-wrapper-2">Trang chủ</span>
        </a>
        <a class="link-2" href="${pageContext.request.contextPath}/kham-pha">
            <span class="text-wrapper-3">Khám phá</span>
        </a>
        <span class="container-wrapper" aria-hidden="true">
            <i class="fa-solid fa-chevron-down img"></i>
        </span>
        <a class="link-3" href="${pageContext.request.contextPath}/dau-gia">
            <span class="container-3" aria-hidden="true">
                <span class="background-2"></span>
            </span>
            <span class="div">
                <span class="text-wrapper-3">Đấu giá</span>
            </span>
        </a>
        <div class="nav">
            <a class="link-4" href="${pageContext.request.contextPath}/cong-dong">
                <span class="text-wrapper-3">Cộng đồng</span>
            </a>
        </div>
    </nav>

    <div class="container-4">
        <button class="link-5" type="button" onclick="location.href='seller-manage.jsp'">
            <span class="link-shadow" aria-hidden="true"></span>
            <span class="div">
                <i class="fa-solid fa-circle-plus icon-2" aria-hidden="true"></i>
            </span>
            <span class="div">
                <span class="p">+ Đăng bài / Trade</span>
            </span>
        </button>

        <div class="container-5">
            <!-- Icon Kệ sách / Wishlist -->
            <button class="div-2" type="button" aria-label="Kệ sách yêu thích">
                <span class="div">
                    <i class="fa-regular fa-heart icon-3" aria-hidden="true"></i>
                </span>
                <span class="background-4" aria-label="3 mục yêu thích">
                    <span class="text-wrapper-4">3</span>
                </span>
            </button>

            <!-- Icon Giỏ hàng -->
            <button class="div-2" type="button" aria-label="Giỏ hàng">
                <span class="div">
                    <i class="fa-solid fa-cart-shopping icon-4" aria-hidden="true"></i>
                </span>
                <span class="background-4" aria-label="1 sản phẩm trong giỏ">
                    <span class="text-wrapper-4">1</span>
                </span>
            </button>

            <!-- Icon Chuông thông báo -->
            <button class="div-2" type="button" aria-label="Thông báo mới">
                <span class="icon-wrapper">
                    <i class="fa-regular fa-bell icon-5" aria-hidden="true"></i>
                </span>
                <span class="overlay-shadow-wrapper" aria-hidden="true">
                    <span class="overlay-shadow"></span>
                </span>
            </button>
        </div>

        <!-- Avatar người dùng có tích xác thực -->
        <div class="user-avatar-frame">
            <img class="container-6" src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80" alt="Ảnh đại diện người dùng">
            <span class="user-verify-tag"><i class="fa-solid fa-check"></i></span>
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
                    <li class="div-3"><a class="text" href="${pageContext.request.contextPath}/danh-muc-manga">Danh mục Manga</a></li>
                    <li class="div-3" aria-hidden="true"><span class="text-wrapper">/</span></li>
                    <li class="div-3"><a class="text" href="${pageContext.request.contextPath}/danh-muc-manga/shonen">Shonen</a></li>
                    <li class="div-3" aria-hidden="true"><span class="text-wrapper">/</span></li>
                    <li class="div-3"><a class="text" href="${pageContext.request.contextPath}/manga/one-piece">One Piece</a></li>
                    <li class="div-3" aria-hidden="true"><span class="text-wrapper">/</span></li>
                    <li class="div-3" aria-current="page"><span class="p">One Piece - Tập 1 (Bản in đầu 2003)</span></li>
                </ol>
            </div>
        </div>
    </nav>
    <main>
        <div class="div-wrapper">
            <div class="primary-showcase">
                <section class="left-column-gallery" aria-label="Hình ảnh sản phẩm">
                    <div class="main-visual-stage">
                        <div class="interactive-aspect" role="img" aria-label="Hình ảnh One Piece tập 1 bản in đầu năm 2003">
                            <div class="div-4"></div>
                            <div class="high-precision">
                                <div class="div-3"><i class="fa-solid fa-magnifying-glass-plus img-zoom"></i></div>
                                <p class="text-5">Hover để soi thớ giấy &amp; mép gáy x60</p>
                            </div>
                        </div>
                    </div>
                    <div class="div-7" role="group" aria-label="Các góc chụp sản phẩm">
                        <button class="button" type="button" aria-label="Xem bìa trước">
                            <div class="margin-2"><div class="div-wrapper-2"><div class="abaxubynucrvp"></div></div></div>
                            <div class="container-2"><span class="text-8">Bìa trước</span></div>
                        </button>
                        <button class="button" type="button" aria-label="Xem bìa sau">
                            <div class="margin-2"><div class="div-wrapper-2"><div class="div-8"></div></div></div>
                            <div class="container-3"><span class="text-8">Bìa sau</span></div>
                        </button>
                        <button class="button" type="button" aria-label="Xem gáy sách">
                            <div class="margin-2"><div class="div-wrapper-2"><div class="div-9"></div></div></div>
                            <div class="container-2"><span class="text-8">Gáy sách</span></div>
                        </button>
                        <button class="button" type="button" aria-label="Xem mép trên">
                            <div class="margin-2"><div class="div-wrapper-2"><div class="div-10"></div></div></div>
                            <div class="container-3"><span class="text-8">Mép trên (ố 10%)</span></div>
                        </button>
                        <button class="button" type="button" aria-label="Xem mép dưới">
                            <div class="margin-2"><div class="div-wrapper-2"><div class="div-11"></div></div></div>
                            <div class="container-3"><span class="text-8">Mép dưới</span></div>
                        </button>
                        <button class="button" type="button" aria-label="Xem bìa lót và Obi">
                            <div class="margin-2"><div class="div-wrapper-2"><div class="div-12"></div></div></div>
                            <div class="container-2"><span class="text-8">Bìa lót &amp; Obi</span></div>
                        </button>
                    </div>
                </section>
                <section class="right-column" aria-labelledby="product-title">
                    <header class="manga-title-series">
                        <div class="container-4">
                            <div class="text-wrapper-2"><span class="text-12">SHŌNEN JUMP 2003</span></div>
                            <div class="div-3"><p class="text">Lưu kho: Kho lạnh #HN-02</p></div>
                        </div>
                        <div class="heading">
                            <h1 class="one-piece-t-p-b-a" id="product-title">One Piece - Tập 1 (Bìa Rời Gốc, Bản In<br>Đầu 2003)</h1>
                        </div>
                        <div class="div-wrapper-3">
                            <p class="t-c-ph-m-kinh-i-n-c">Tác phẩm kinh điển của Eiichiro Oda. Ấn bản xuất xưởng đầu tiên tại thị trường<br>phát hành, giữ nguyên bìa áo gập mép và sắc độ màu rực rỡ chưa suy giảm qua<br>hơn 2 thập kỷ.</p>
                        </div>
                    </header>
                    <section class="condition-provenance" aria-label="Tình trạng và nguồn gốc">
                        <div class="container-4">
                            <div class="div-3"><i class="fa-solid fa-certificate icon-check-cert"></i></div>
                            <div class="div-3"><p class="text-13">Tình trạng: Like New 95% • Giấy ố nhẹ viền theo 21 năm</p></div>
                        </div>
                        <div class="container-5">
                            <div class="background-shadow-4"><div class="div-13"></div><p class="text-5">Bản in đầu 2003 (1st Edition)</p></div>
                            <div class="background-shadow-5"><div class="div-14"></div><p class="text-5">Đầy đủ Obi &amp; Bookmark gốc</p></div>
                            <div class="background-shadow-6"><div class="div-15"></div><p class="text-5">Chưa qua hóa chất tẩy ố</p></div>
                        </div>
                    </section>
                    <section class="seller-dossier-box" aria-label="Thông tin người bán">
                        <div class="container-6">
                            <div class="div">
                                <div class="div-wrapper-4"><div class="div-16"></div></div>
                                <div class="div-3">
                                    <div class="container-7">
                                        <div class="div-3"><span class="text-wrapper-3">Kenji Vault</span></div>
                                        <div class="div-3"><i class="fa-solid fa-circle-check icon-seller-verified"></i></div>
                                    </div>
                                    <div class="container-8">
                                        <div class="container-9">
                                            <div class="div-3"><i class="fa-solid fa-star icon-rating-star"></i></div>
                                            <span class="text-14">4.9/5</span>
                                        </div>
                                        <div class="div-3"><span class="text">•</span></div>
                                        <div class="div-3"><p class="text">38 giao dịch thành công</p></div>
                                    </div>
                                </div>
                            </div>
                            <div class="container-10"><div class="div-17"><div class="div-13"></div><span class="text-15">&lt; 15 phút</span></div></div>
                        </div>
                        <div class="container-11">
                            <a class="link" href="${pageContext.request.contextPath}/seller/kenji-vault">
                                <div class="div-3"><i class="fa-solid fa-book-open icon-action"></i></div>
                                <span class="text-9">Tủ sách (24 cuốn)</span>
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
                                <div class="paragraph"><span class="text-16">450.000</span><span class="text-17">đ</span></div>
                                <div class="container-14"><div class="div-3"><span class="text-18">550.000 đ</span></div><div class="text-wrapper-4"><span class="text-19">-18%</span></div></div>
                            </div>
                            <div class="container-15">
                                <div class="div-3"><i class="fa-solid fa-shield-halved icon-labs"></i></div>
                                <div class="div-3"><p class="text">Đã hoàn tất giám định vật lý bởi MangaVault Labs</p></div>
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
                                <div class="img-wrapper"><i class="fa-solid fa-arrow-right-arrow-left icon-trade"></i></div>
                                <div class="container-16">
                                    <p class="text-20">
                                        <span class="span">Lựa chọn Trao đổi (Trade):</span>
                                        <span class="text-wrapper-6">Người bán sẵn sàng đổi ngang với</span><span class="span"><br></span>
                                        <span class="text-wrapper-7">Bleach Tập 1 (2008)</span><span class="text-wrapper-6"> hoặc </span><span class="text-wrapper-7">Dragon Ball 1996</span><span class="text-wrapper-6"> bìa đẹp (thương lượng</span><span class="span"><br></span>
                                        <span class="text-wrapper-6">bù trừ qua sàn).</span>
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
                    Ấn Bản Manga Sưu Tầm Đặc Biệt &amp; Giá Trị Lịch Sử
                </h2>
                <div class="intro-content">
                    <p>
                        Bộ truyện <strong>One Piece - Tập 1 (Bản in đầu 2003)</strong> là một trong những ấn phẩm manga hiếm và có giá trị sưu tầm bậc nhất trên thị trường hiện nay[cite: 10]. Tác phẩm giữ trọn vẹn chất lượng từ ngày đầu phát hành với đầy đủ bìa rời, bìa áo nguyên bản, cùng các phụ kiện đi kèm như Bookmark và Obi zin chưa qua can thiệp tẩy ố[cite: 10].
                    </p>
                    <p>
                        Đây là lựa chọn lý tưởng dành cho những nhà sưu tầm đang tìm kiếm mảnh ghép hoàn thiện cho kệ sách của mình, được đảm bảo chất lượng và quy trình lưu kho tiêu chuẩn qua cơ chế ký quỹ an toàn của hệ thống[cite: 1, 2].
                    </p>
                </div>
            </section>
        </div>

        <!-- Khối Bộ Sưu Tập Tương Quan -->
        <div class="div-wrapper">
            <section class="div-18" aria-labelledby="related-title">
                <header class="container-18">
                    <div class="div-3">
                        <div class="div-wrapper-3"><p class="text-3">BỘ SƯU TẬP TƯƠNG QUAN</p></div>
                        <div class="div-wrapper-3"><h2 class="text-26" id="related-title">Tập Khác Cùng Bộ &amp; Bản Hiếm Tuyển Chọn</h2></div>
                    </div>
                    <a class="div-2 link-vault" href="${pageContext.request.contextPath}/manga/one-piece">
                        <span class="text-25">Xem tất cả One Piece Vault</span>
                        <div class="div-3"><i class="fa-solid fa-arrow-right icon-arrow"></i></div>
                    </a>
                </header>
                <div class="container-19">
                    <article class="link-card">
                        <div class="container-20"><span class="text-wrapper-8">ONE PIECE #2</span></div>
                        <div class="heading-2"><h3 class="text-wrapper-3">Tập 2: Chàng Thợ Săn Hải Tặc</h3></div>
                        <div class="margin-3">
                            <div class="container-21">
                                <div class="div-3"><span class="text-wrapper-3">380.000 đ</span></div>
                                <div class="div-3"><span class="text-10">Grade 8.8</span></div>
                            </div>
                        </div>
                        <div class="margin-4">
                            <div class="div-27">
                                <div class="div-28"></div>
                                <div class="text-wrapper-9"><span class="text-5">1st Edition</span></div>
                            </div>
                        </div>
                    </article>
                    <article class="link-card">
                        <div class="container-20"><span class="text-wrapper-8">ONE PIECE #4</span></div>
                        <div class="heading-2"><h3 class="text-wrapper-3">Tập 4: Lưỡi Kiếm Nguyện Ước</h3></div>
                        <div class="margin-3">
                            <div class="container-22">
                                <div class="div-3"><span class="text-wrapper-3">420.000 đ</span></div>
                                <div class="div-3"><span class="text-10">Grade 9.0</span></div>
                            </div>
                        </div>
                        <div class="margin-4">
                            <div class="div-27">
                                <div class="div-29"></div>
                                <div class="text-wrapper-9"><span class="text-5">Kèm Obi Gốc</span></div>
                            </div>
                        </div>
                    </article>
                    <article class="link-card">
                        <div class="container-20"><span class="text-wrapper-8">DRAGON BALL 1996</span></div>
                        <div class="heading-2"><h3 class="text-wrapper-3">Tập 1: Viên Ngọc Rồng Đầu Tiên</h3></div>
                        <div class="margin-3">
                            <div class="container-21">
                                <div class="div-3"><span class="text-wrapper-3">1.250.000 đ</span></div>
                                <div class="div-3"><span class="text-10">Grade 8.5</span></div>
                            </div>
                        </div>
                        <div class="margin-4">
                            <div class="div-27">
                                <div class="div-30"></div>
                                <div class="text-wrapper-10"><span class="text-7">Hiếm Cực Độ</span></div>
                            </div>
                        </div>
                    </article>
                    <article class="link-card">
                        <div class="container-20"><span class="text-wrapper-8">BLEACH #1</span></div>
                        <div class="heading-2"><h3 class="text-wrapper-3">Tập 1: Tử Thần &amp; Dâu Tây</h3></div>
                        <div class="margin-3">
                            <div class="container-22">
                                <div class="div-3"><span class="text-wrapper-3">520.000 đ</span></div>
                                <div class="div-3"><span class="text-10">Grade 9.4</span></div>
                            </div>
                        </div>
                        <div class="margin-4">
                            <div class="div-27">
                                <div class="abaxudrqyaftmqmvbm"></div>
                                <div class="text-wrapper-9"><span class="text-5">Bản In 2008</span></div>
                            </div>
                        </div>
                    </article>
                </div>
            </section>
        </div>
    </main>
</div>
<footer class="footer">
    <div class="container">
        <section class="div" aria-label="Thông tin MangaVault">
            <!-- Cột 1: Thông tin thương hiệu -->
            <section class="container-2" aria-labelledby="brand-name">
                <div class="div-wrapper">
                    <div class="text-wrapper" id="brand-name">MangaVault</div>
                </div>
                <div class="s-n-giao-d-ch-truy-n-wrapper">
                    <p class="s-n-giao-d-ch-truy-n">
                        Sàn giao dịch truyện tranh, ấn bản<br>
                        hiếm &amp; vật phẩm sưu tầm xác thực<br>
                        bản quyền số 1 tại Đông Nam Á.
                    </p>
                </div>
                <div class="background-border" aria-label="100% bảo chứng Escrow">
                    <div class="container-3">
                        <i class="fa-solid fa-shield-halved icon"></i>
                    </div>
                    <div class="text">100% BẢO CHỨNG ESCROW</div>
                </div>
            </section>

            <!-- Cột 2: Danh mục -->
            <nav class="container-4" aria-labelledby="archive-heading">
                <div class="div-wrapper">
                    <h2 class="text-wrapper-2" id="archive-heading">DANH MỤC LƯU TRỮ</h2>
                </div>
                <ul class="list">
                    <li class="div-wrapper"><a href="${pageContext.request.contextPath}/danh-muc-manga/shonen" class="text-wrapper-3">Shonen Originals</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Seinen Masterpieces</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Shojo Vintage Classics</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Tankōbon First Editions</a></li>
                </ul>
            </nav>

            <!-- Cột 3: Dịch vụ -->
            <nav class="container-4" aria-labelledby="collector-heading">
                <div class="div-wrapper">
                    <h2 class="text-wrapper-2" id="collector-heading">DỊCH VỤ COLLECTOR</h2>
                </div>
                <ul class="list">
                    <li class="div-wrapper"><a href="${pageContext.request.contextPath}/dau-gia" class="text-wrapper-3">Đấu Giá Trực Tiếp</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Thẩm Định &amp; Đóng Slab</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Lịch Private Drops</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Ký Quỹ Ví Vault</a></li>
                </ul>
            </nav>

            <!-- Cột 4: Ký quỹ & Pháp lý -->
            <nav class="container-4" aria-labelledby="legal-heading">
                <div class="div-wrapper">
                    <h2 class="text-wrapper-2" id="legal-heading">KÝ QUỸ &amp; PHÁP LÝ</h2>
                </div>
                <ul class="list">
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Bảo Hiểm Ký Quỹ Escrow</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Quy Trình Giám Định Sàn</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Chính Sách Hoàn Tiền 100%</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Điều Khoản Sử Dụng Sàn</a></li>
                </ul>
            </nav>

            <!-- Cột 5: Hỗ trợ -->
            <nav class="container-5" aria-labelledby="support-heading">
                <div class="div-wrapper">
                    <h2 class="text-wrapper-2" id="support-heading">TRUNG TÂM HỖ TRỢ</h2>
                </div>
                <ul class="list">
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Yêu Cầu Hỗ Trợ 24/7</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Quy Chuẩn Đóng Gói Manga</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Tra Cứu Mã Chứng Thư (API)</a></li>
                    <li class="div-wrapper"><a href="#" class="text-wrapper-3">Quan Hệ Đối Tác &amp; NXB</a></li>
                </ul>
            </nav>
        </section>

        <!-- Dòng bản quyền & Chứng nhận phía dưới -->
        <section class="horizontal-border" aria-label="Thông tin bản quyền và bảo mật">
            <div class="container-3">
                <p class="text-2">© 2026 MangaVault Exchange Inc. Mọi quyền được bảo lưu.</p>
            </div>
            <div class="container-6">
                <div class="container-3">
                    <p class="text-2">Bảo mật dữ liệu ISO 27001</p>
                </div>
                <div class="container-3" aria-hidden="true">
                    <div class="text-2">•</div>
                </div>
                <div class="container-3">
                    <p class="text-2">Chứng thực chữ ký số SHA-256</p>
                </div>
            </div>
        </section>
    </div>
</footer>
</body>
</html>
