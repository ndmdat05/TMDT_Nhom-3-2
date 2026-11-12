<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chỉnh sửa sản phẩm - MangaZ Seller</title>
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
      <h4 class="fw-bold mb-0"><i class="fas fa-edit text-danger me-2"></i>Chỉnh sửa sản phẩm #${product.id}</h4>
      <c:choose>
        <c:when test="${product.status == 'APPROVED'}"><span class="badge bg-success">Đang hiển thị</span></c:when>
        <c:when test="${product.status == 'PENDING_APPROVAL'}"><span class="badge bg-warning text-dark">Chờ duyệt</span></c:when>
        <c:when test="${product.status == 'REJECTED'}"><span class="badge bg-danger">Bị từ chối</span></c:when>
        <c:when test="${product.status == 'HIDDEN'}"><span class="badge bg-secondary">Đang ẩn</span></c:when>
      </c:choose>
    </div>

    <c:if test="${product.status == 'REJECTED' && not empty product.rejectionReason}">
      <div class="alert alert-danger">
        <b>Lý do bị từ chối:</b> <c:out value="${product.rejectionReason}"/>
        <div class="small mt-1">Sửa lại và gửi duyệt lại — Admin sẽ xem xét lần hai.</div>
      </div>
    </c:if>

    <div class="alert alert-info py-2 small">
      <i class="fas fa-info-circle me-1"></i> Nếu sản phẩm đang <b>hiển thị</b> hoặc <b>bị từ chối</b>, sau khi lưu sẽ chuyển về <b>Chờ duyệt</b> để Admin duyệt lại.
    </div>

    <!-- QUAN TRỌNG: enctype multipart/form-data -->
    <form action="seller-manage" method="post" enctype="multipart/form-data">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="id" value="${product.id}">

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
          <input type="number" name="stockQuantity" class="form-control" min="0" value="${product.stockQuantity}">
        </div>
      </div>

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
        <button type="submit" class="btn btn-danger"><i class="fas fa-save me-1"></i> Lưu & Gửi duyệt lại</button>
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
</script>
</body>
</html>