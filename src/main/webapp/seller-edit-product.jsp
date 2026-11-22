<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>${empty product ? 'Đăng bán sản phẩm mới' : 'Chỉnh sửa sản phẩm'} - MangaZ</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">
<jsp:include page="includes/header.jsp" />

<main class="container my-5" style="max-width: 900px;">
  <a href="seller-manage?action=products" class="text-decoration-none text-muted small mb-3 d-inline-block">
    <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách sản phẩm
  </a>

  <div class="bg-white rounded shadow-sm p-4">
    <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
      <h4 class="fw-bold mb-0">
        <i class="fas fa-edit text-danger me-2"></i>
        ${empty product ? 'Đăng bán sản phẩm mới' : 'Chỉnh sửa sản phẩm #'.concat(product.id)}
      </h4>
      <c:if test="${not empty product}">
        <c:choose>
          <c:when test="${product.status == 'APPROVED'}"><span class="badge bg-success">Đang hiển thị</span></c:when>
          <c:when test="${product.status == 'PENDING_APPROVAL'}"><span class="badge bg-warning text-dark">Chờ duyệt</span></c:when>
          <c:when test="${product.status == 'REJECTED'}"><span class="badge bg-danger">Bị từ chối</span></c:when>
          <c:when test="${product.status == 'HIDDEN'}"><span class="badge bg-secondary">Đang ẩn</span></c:when>
        </c:choose>
      </c:if>
    </div>

    <form action="seller-manage" method="post" enctype="multipart/form-data">
      <!-- Nếu là update thì truyền action=update và id, ngược lại là add -->
      <input type="hidden" name="action" value="${empty product ? 'add' : 'update'}">
      <c:if test="${not empty product}">
        <input type="hidden" name="id" value="${product.id}">
      </c:if>

      <!-- THÔNG TIN CƠ BẢN -->
      <div class="mb-3">
        <label class="form-label fw-semibold">Tên truyện <span class="text-danger">*</span></label>
        <input type="text" name="title" class="form-control" required maxlength="255" value="<c:out value='${product.title}'/>">
      </div>

      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label fw-semibold">Thể loại</label>
          <select name="categoryId" class="form-select">
            <option value="">-- Chọn thể loại --</option>
            <c:forEach var="c" items="${categoryList}">
              <option value="${c.id}" ${product.categories_id == c.id ? 'selected' : ''}><c:out value="${c.name}"/></option>
            </c:forEach>
          </select>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label fw-semibold">Nhà xuất bản</label>
          <select name="brandId" class="form-select">
            <option value="">-- Chọn NXB --</option>
            <c:forEach var="b" items="${brandList}">
              <option value="${b.id}" ${product.brandId == b.id ? 'selected' : ''}><c:out value="${b.name}"/></option>
            </c:forEach>
          </select>
        </div>
      </div>

      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label fw-semibold">Tên bộ truyện (Series)</label>
          <input type="text" name="seriesName" class="form-control" maxlength="255" value="<c:out value='${product.seriesName}'/>">
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label fw-semibold">Tác giả</label>
          <input type="text" name="author" class="form-control" maxlength="255" value="<c:out value='${product.author}'/>">
        </div>
      </div>

      <div class="row">
        <div class="col-md-4 mb-3">
          <label class="form-label fw-semibold">Tập số</label>
          <input type="number" name="volumeNumber" class="form-control" min="1" value="${product.volumeNumber}">
        </div>
        <div class="col-md-8 mb-3">
          <label class="form-label fw-semibold">Phiên bản</label>
          <input type="text" name="edition" class="form-control" maxlength="100" value="<c:out value='${product.edition}'/>">
        </div>
      </div>

      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label fw-semibold">Tình trạng <span class="text-danger">*</span></label>
          <select name="itemCondition" class="form-select" required>
            <option value="NEW" ${product.itemCondition == 'NEW' ? 'selected' : ''}>Mới 100% (Seal)</option>
            <option value="LIKE_NEW" ${product.itemCondition == 'LIKE_NEW' ? 'selected' : ''}>Like New (Sưu tầm)</option>
            <option value="USED" ${product.itemCondition == 'USED' ? 'selected' : ''}>Đã qua sử dụng</option>
          </select>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label fw-semibold">Ngôn ngữ</label>
          <select name="language" class="form-select">
            <option value="Tiếng Việt" ${product.language == 'Tiếng Việt' ? 'selected' : ''}>Tiếng Việt</option>
            <option value="Tiếng Nhật" ${product.language == 'Tiếng Nhật' ? 'selected' : ''}>Tiếng Nhật</option>
            <option value="Tiếng Anh" ${product.language == 'Tiếng Anh' ? 'selected' : ''}>Tiếng Anh</option>
          </select>
        </div>
      </div>

      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label fw-semibold">Giá bán (VNĐ) <span class="text-danger">*</span></label>
          <input type="number" name="price" class="form-control" required min="0" step="1000" value="${product.price}">
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label fw-semibold">Tồn kho</label>
          <input type="number" name="stockQuantity" class="form-control" min="0" value="${empty product ? 1 : product.stockQuantity}">
        </div>
      </div>

      <!-- KHỐI ĐẤU GIÁ (Chỉ hiển thị khi THÊM MỚI) -->
      <c:if test="${empty product}">
        <div class="mb-4 p-3 bg-orange-50 border border-orange-200 rounded">
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" id="isAuction" name="isAuction" value="true" onchange="toggleAuctionFields()">
            <label class="form-check-label fw-bold text-orange-800" for="isAuction">Đăng bán dưới hình thức Đấu giá</label>
          </div>
          <div id="auctionFields" class="mt-3 row d-none">
            <div class="col-md-4">
              <label class="form-label small fw-bold">Giá khởi điểm (VNĐ)</label>
              <input type="number" name="startingPrice" class="form-control" min="0" step="1000">
            </div>
            <div class="col-md-4">
              <label class="form-label small fw-bold">Bước giá (VNĐ)</label>
              <input type="number" name="bidStep" class="form-control" value="10000" min="1000" step="1000">
            </div>
            <div class="col-md-4">
              <label class="form-label small fw-bold">Thời gian kết thúc</label>
              <input type="datetime-local" name="endTime" class="form-control">
            </div>
          </div>
        </div>
      </c:if>

      <!-- ẢNH BÌA -->
      <div class="mb-3 p-3 bg-light rounded border">
        <label class="form-label fw-semibold d-block mb-1">Ảnh bìa</label>
        <div class="mb-2">
          <label class="small text-muted mb-1">Tải ảnh mới lên (Nếu muốn thay đổi)</label>
          <input type="file" name="imageFile" class="form-control" accept="image/*" onchange="previewImage(event)">
        </div>
        <div class="text-center my-2 text-muted small">--- HOẶC ---</div>
        <div class="mb-2">
          <label class="small text-muted mb-1">Dán URL ảnh mới</label>
          <input type="text" name="imageUrl" class="form-control" value="<c:out value='${product.imageUrl}'/>" placeholder="https://...">
        </div>
        <div class="mt-2 text-center">
          <c:if test="${not empty product.imageUrl}">
            <img id="imagePreview" src="${product.imageUrl}" alt="Preview" class="img-thumbnail" style="max-height: 150px;">
          </c:if>
          <c:if test="${empty product.imageUrl}">
            <img id="imagePreview" src="" alt="Preview" class="img-thumbnail d-none" style="max-height: 150px;">
          </c:if>
        </div>
      </div>

      <div class="mb-4">
        <label class="form-label fw-semibold">Mô tả</label>
        <textarea name="description" class="form-control" rows="5" maxlength="5000"><c:out value="${product.description}"/></textarea>
      </div>

      <div class="d-flex justify-content-end gap-2 border-top pt-3">
        <a href="seller-manage?action=products" class="btn btn-outline-secondary">Hủy</a>
        <button type="submit" class="btn btn-danger"><i class="fas fa-save me-1"></i> ${empty product ? 'Đăng bán' : 'Lưu & Gửi duyệt lại'}</button>
      </div>
    </form>
  </div>
</main>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function previewImage(event) {
    const file = event.target.files[0];
    const preview = document.getElementById('imagePreview');
    if (file) {
      const reader = new FileReader();
      reader.onload = function(e) {
        preview.src = e.target.result;
        preview.classList.remove('d-none');
      }
      reader.readAsDataURL(file);
    }
  }

  function toggleAuctionFields() {
    var cb = document.getElementById('isAuction');
    var f = document.getElementById('auctionFields');
    if (cb.checked) f.classList.remove('d-none'); else f.classList.add('d-none');
  }
</script>
</body>
</html>