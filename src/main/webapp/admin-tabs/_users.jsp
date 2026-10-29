
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!-- ===================== HEADER ===================== -->
<div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4 mb-6">
    <div>
        <h1 class="text-2xl font-bold text-gray-900">Quản lý người dùng</h1>
        <p class="text-sm text-gray-500 mt-1">
            Quản lý tài khoản, vai trò và trạng thái hoạt động.
        </p>
    </div>

    <button type="button"
            onclick="openUserModal('add')"
            class="inline-flex items-center justify-center gap-2 px-4 py-2.5
                   rounded-lg bg-indigo-600 text-white font-semibold
                   hover:bg-indigo-700 transition shadow-sm">
        <i class="fas fa-user-plus"></i>
        Thêm người dùng
    </button>
</div>

<!-- ===================== NOTIFICATIONS ===================== -->
<c:if test="${not empty requestScope.adminError}">
    <div class="mb-5 flex items-start gap-3 rounded-lg border border-red-200
                bg-red-50 px-4 py-3 text-sm text-red-700">
        <i class="fas fa-circle-exclamation mt-0.5"></i>
        <div><c:out value="${requestScope.adminError}"/></div>
    </div>
</c:if>

<c:if test="${not empty requestScope.adminSuccess}">
    <div class="mb-5 flex items-start gap-3 rounded-lg border border-emerald-200
                bg-emerald-50 px-4 py-3 text-sm text-emerald-700">
        <i class="fas fa-circle-check mt-0.5"></i>
        <div><c:out value="${requestScope.adminSuccess}"/></div>
    </div>
</c:if>

<!-- ===================== SEARCH AND FILTER ===================== -->
<div class="bg-white border border-gray-200 rounded-xl shadow-sm p-4 mb-5">
    <form action="${ctx}/admin/manage" method="get"
          class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-3">

        <input type="hidden" name="tab" value="users">

        <div class="xl:col-span-2 relative">
            <i class="fas fa-search absolute left-3 top-1/2
                      -translate-y-1/2 text-gray-400"></i>

            <input type="text"
                   name="q"
                   value="<c:out value='${searchKeyword}'/>"
                   placeholder="Tìm tên, email hoặc username..."
                   class="w-full rounded-lg border border-gray-300 py-2.5 pl-10 pr-3
                          text-sm outline-none focus:border-indigo-500
                          focus:ring-2 focus:ring-indigo-100">
        </div>

        <div>
            <select name="status"
                    class="w-full rounded-lg border border-gray-300 px-3 py-2.5
                           text-sm bg-white outline-none focus:border-indigo-500">
                <option value="">Tất cả trạng thái</option>
                <option value="ACTIVE"
                ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>
                    Đang hoạt động
                </option>
                <option value="LOCKED"
                ${param.status == 'LOCKED' ? 'selected' : ''}>
                    Đã khóa
                </option>
            </select>
        </div>

        <div class="flex gap-2">
            <button type="submit"
                    class="flex-1 inline-flex items-center justify-center gap-2
                           rounded-lg bg-indigo-600 px-4 py-2.5 text-sm
                           font-semibold text-white hover:bg-indigo-700 transition">
                <i class="fas fa-filter"></i>
                Lọc
            </button>

            <a href="${ctx}/admin/manage?tab=users"
               class="inline-flex items-center justify-center rounded-lg
                      border border-gray-300 px-4 py-2.5 text-sm
                      text-gray-600 hover:bg-gray-50 transition"
               title="Xóa bộ lọc">
                <i class="fas fa-rotate-left"></i>
            </a>
        </div>
    </form>
</div>

<!-- ===================== USER TABLE ===================== -->
<div class="bg-white border border-gray-200 rounded-xl shadow-sm overflow-hidden">
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between
                gap-2 px-5 py-4 border-b border-gray-200">
        <div>
            <h2 class="font-bold text-gray-900">Danh sách tài khoản</h2>
            <p class="text-xs text-gray-500 mt-1">
                Dữ liệu được cung cấp bởi AdminManageServlet.
            </p>
        </div>

        <span class="text-xs text-gray-500">
            <i class="fas fa-database mr-1"></i>
            Người dùng
        </span>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full min-w-[1000px] text-left text-sm">
            <thead class="bg-gray-50 text-xs uppercase text-gray-500
                          border-b border-gray-200">
            <tr>
                <th class="px-5 py-4 font-semibold w-20">ID</th>
                <th class="px-5 py-4 font-semibold">Thông tin người dùng</th>
                <th class="px-5 py-4 font-semibold">Vai trò</th>
                <th class="px-5 py-4 font-semibold">Trạng thái</th>
                <th class="px-5 py-4 font-semibold">Ngày đăng ký</th>
                <th class="px-5 py-4 font-semibold text-right">Thao tác</th>
            </tr>
            </thead>

            <tbody class="divide-y divide-gray-100">
            <c:choose>
                <c:when test="${not empty userList}">
                    <c:forEach var="user" items="${userList}">
                        <tr class="hover:bg-gray-50 transition-colors">

                            <!-- ID -->
                            <td class="px-5 py-4 font-semibold text-gray-700">
                                #<c:out value="${user.id}"/>
                            </td>

                            <!-- USER INFORMATION / AVATAR -->
                            <td class="px-5 py-4">
                                <div class="flex items-center gap-3 min-w-0">

                                    <c:choose>
                                        <c:when test="${not empty user.avatar_url}">
                                            <img
                                                    src="<c:out value='${user.avatar_url}'/>"
                                                    alt="Avatar"
                                                    class="user-avatar w-11 h-11 shrink-0
                                                           rounded-full object-cover
                                                           border border-gray-200 bg-gray-100"
                                                    onerror="this.onerror=null;
                                                             this.classList.add('hidden');
                                                             this.nextElementSibling.classList.remove('hidden');
                                                             this.nextElementSibling.classList.add('flex');">

                                            <div class="hidden w-11 h-11 shrink-0
                                                            rounded-full bg-indigo-100
                                                            text-indigo-700 items-center
                                                            justify-center border border-indigo-200">
                                                <i class="fas fa-user"></i>
                                            </div>
                                        </c:when>

                                        <c:otherwise>
                                            <div class="flex w-11 h-11 shrink-0
                                                            rounded-full bg-indigo-100
                                                            text-indigo-700 items-center
                                                            justify-center border border-indigo-200">
                                                <i class="fas fa-user"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="min-w-0">
                                        <p class="font-semibold text-gray-900 truncate
                                                      max-w-[280px]">
                                            <c:choose>
                                                <c:when test="${not empty user.full_name}">
                                                    <c:out value="${user.full_name}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    Chưa cập nhật tên
                                                </c:otherwise>
                                            </c:choose>
                                        </p>

                                        <p class="text-xs text-gray-500 truncate
                                                      max-w-[280px] mt-0.5">
                                            <c:out value="${user.email}"/>
                                        </p>

                                        <p class="text-xs text-gray-400 truncate
                                                      max-w-[280px] mt-0.5">
                                            @<c:out value="${user.username}"/>
                                        </p>
                                    </div>
                                </div>
                            </td>

                            <!-- ROLE -->
                            <td class="px-5 py-4">
                                <c:choose>
                                    <c:when test="${user.role == 'ADMIN'}">
                                            <span class="inline-flex items-center gap-1.5
                                                         px-2.5 py-1 rounded-md text-xs
                                                         font-semibold bg-purple-50
                                                         text-purple-700 border border-purple-200">
                                                <i class="fas fa-shield-halved"></i>
                                                Quản trị
                                            </span>
                                    </c:when>

                                    <c:when test="${user.role == 'SELLER'}">
                                            <span class="inline-flex items-center gap-1.5
                                                         px-2.5 py-1 rounded-md text-xs
                                                         font-semibold bg-blue-50
                                                         text-blue-700 border border-blue-200">
                                                <i class="fas fa-store"></i>
                                                Người bán
                                            </span>
                                    </c:when>

                                    <c:otherwise>
                                            <span class="inline-flex items-center gap-1.5
                                                         px-2.5 py-1 rounded-md text-xs
                                                         font-semibold bg-gray-100
                                                         text-gray-700 border border-gray-200">
                                                <i class="fas fa-user"></i>
                                                Người mua
                                            </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- STATUS -->
                            <td class="px-5 py-4">
                                <c:choose>
                                    <c:when test="${user.status == 'ACTIVE'}">
                                            <span class="inline-flex items-center gap-2
                                                         px-2.5 py-1 rounded-full text-xs
                                                         font-semibold bg-emerald-50
                                                         text-emerald-700">
                                                <span class="w-1.5 h-1.5 rounded-full
                                                             bg-emerald-500"></span>
                                                Hoạt động
                                            </span>
                                    </c:when>

                                    <c:when test="${user.status == 'LOCKED'}">
                                            <span class="inline-flex items-center gap-2
                                                         px-2.5 py-1 rounded-full text-xs
                                                         font-semibold bg-red-50 text-red-700">
                                                <span class="w-1.5 h-1.5 rounded-full
                                                             bg-red-500"></span>
                                                Đã khóa
                                            </span>
                                    </c:when>

                                    <c:otherwise>
                                            <span class="inline-flex items-center gap-2
                                                         px-2.5 py-1 rounded-full text-xs
                                                         font-semibold bg-gray-100 text-gray-600">
                                                <span class="w-1.5 h-1.5 rounded-full
                                                             bg-gray-400"></span>
                                                <c:out value="${user.status}"/>
                                            </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- CREATED AT -->
                            <td class="px-5 py-4 text-gray-500 text-xs">
                                <c:choose>
                                    <c:when test="${not empty user.created_at}">
                                        <c:out value="${user.created_at}"/>
                                    </c:when>
                                    <c:otherwise>
                                        —
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- ACTIONS -->
                            <td class="px-5 py-4">
                                <div class="flex justify-end items-center gap-2">

                                    <!-- EDIT -->
                                    <button
                                            type="button"
                                            title="Sửa thông tin"
                                            aria-label="Sửa thông tin người dùng"
                                            onclick="openUserModal('edit', this)"
                                            data-id="<c:out value='${user.id}'/>"
                                            data-full-name="<c:out value='${user.full_name}'/>"
                                            data-username="<c:out value='${user.username}'/>"
                                            data-email="<c:out value='${user.email}'/>"
                                            data-role="<c:out value='${user.role}'/>"
                                            data-status="<c:out value='${user.status}'/>"
                                            data-avatar="<c:out value='${user.avatar_url}'/>"
                                            class="inline-flex items-center justify-center
                                                   w-9 h-9 rounded-lg border border-gray-200
                                                   text-indigo-600 hover:bg-indigo-50
                                                   hover:border-indigo-200 transition">
                                        <i class="fas fa-pen"></i>
                                    </button>

                                    <!-- LOCK / UNLOCK -->
                                    <c:if test="${user.role != 'ADMIN'}">
                                        <form action="${ctx}/admin/manage" method="post"
                                              onsubmit="return confirmUserStatus(this);">
                                            <input type="hidden" name="tab" value="users">
                                            <input type="hidden" name="action" value="toggleStatus">
                                            <input type="hidden" name="userId"
                                                   value="<c:out value='${user.id}'/>">

                                            <button type="submit"
                                                    title="${user.status == 'ACTIVE' ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}"
                                                    class="inline-flex items-center justify-center
                                                               w-9 h-9 rounded-lg border transition
                                                               ${user.status == 'ACTIVE'
                                                                 ? 'border-amber-200 text-amber-600 hover:bg-amber-50'
                                                                 : 'border-emerald-200 text-emerald-600 hover:bg-emerald-50'}">
                                                <i class="fas ${user.status == 'ACTIVE'
                                                                    ? 'fa-lock'
                                                                    : 'fa-lock-open'}"></i>
                                            </button>
                                        </form>

                                        <!-- SOFT DELETE -->
                                        <form action="${ctx}/admin/manage" method="post"
                                              onsubmit="return confirmDeleteUser(this);">
                                            <input type="hidden" name="tab" value="users">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="userId"
                                                   value="<c:out value='${user.id}'/>">

                                            <button type="submit"
                                                    title="Xóa người dùng"
                                                    class="inline-flex items-center justify-center
                                                               w-9 h-9 rounded-lg border border-red-200
                                                               text-red-600 hover:bg-red-50 transition">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <tr>
                        <td colspan="6" class="px-6 py-16 text-center">
                            <div class="flex flex-col items-center">
                                <div class="w-14 h-14 rounded-full bg-gray-100
                                                text-gray-400 flex items-center
                                                justify-center mb-3">
                                    <i class="fas fa-users text-xl"></i>
                                </div>
                                <p class="font-semibold text-gray-700">
                                    Không tìm thấy người dùng
                                </p>
                                <p class="text-sm text-gray-500 mt-1">
                                    Thử thay đổi từ khóa hoặc bộ lọc.
                                </p>
                            </div>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<!-- ===================== ADD / EDIT MODAL ===================== -->
<div id="userModal"
     class="fixed inset-0 z-[100] hidden items-center justify-center
            bg-gray-900/50 backdrop-blur-sm p-4">

    <div id="userModalContent"
         class="w-full max-w-xl max-h-[90vh] overflow-y-auto
                rounded-2xl bg-white shadow-2xl">

        <div class="flex items-center justify-between border-b border-gray-200
                    px-6 py-4">
            <div>
                <h2 id="userModalTitle" class="text-xl font-bold text-gray-900">
                    Thêm người dùng
                </h2>
                <p class="text-sm text-gray-500 mt-1">
                    Nhập thông tin tài khoản bên dưới.
                </p>
            </div>

            <button type="button" onclick="closeUserModal()"
                    class="w-9 h-9 rounded-lg text-gray-500 hover:bg-gray-100
                           hover:text-red-500 transition">
                <i class="fas fa-times"></i>
            </button>
        </div>

        <form id="userForm" action="${ctx}/admin/manage" method="post"
              class="p-6 space-y-5">

            <input type="hidden" name="tab" value="users">
            <input type="hidden" id="userAction" name="action" value="add">
            <input type="hidden" id="userId" name="userId" value="">

            <div>
                <label for="userFullName"
                       class="block text-sm font-semibold text-gray-700 mb-1.5">
                    Họ và tên <span class="text-red-500">*</span>
                </label>
                <input id="userFullName" name="fullName" type="text"
                       maxlength="255" required
                       placeholder="Nhập họ và tên"
                       class="w-full rounded-lg border border-gray-300 px-4 py-2.5
                              text-sm outline-none focus:border-indigo-500
                              focus:ring-2 focus:ring-indigo-100">
            </div>

            <div>
                <label for="userUsername"
                       class="block text-sm font-semibold text-gray-700 mb-1.5">
                    Username <span class="text-red-500">*</span>
                </label>
                <input id="userUsername" name="username" type="text"
                       maxlength="100" required
                       placeholder="Nhập username"
                       autocomplete="off"
                       class="w-full rounded-lg border border-gray-300 px-4 py-2.5
                              text-sm outline-none focus:border-indigo-500
                              focus:ring-2 focus:ring-indigo-100">
            </div>

            <div>
                <label for="userEmail"
                       class="block text-sm font-semibold text-gray-700 mb-1.5">
                    Email <span class="text-red-500">*</span>
                </label>
                <input id="userEmail" name="email" type="email"
                       maxlength="255" required
                       placeholder="example@email.com"
                       autocomplete="off"
                       class="w-full rounded-lg border border-gray-300 px-4 py-2.5
                              text-sm outline-none focus:border-indigo-500
                              focus:ring-2 focus:ring-indigo-100">
            </div>

            <div id="passwordField">
                <label for="userPassword"
                       class="block text-sm font-semibold text-gray-700 mb-1.5">
                    Mật khẩu <span id="passwordRequired" class="text-red-500">*</span>
                </label>
                <input id="userPassword" name="password" type="password"
                       minlength="8" autocomplete="new-password"
                       placeholder="Tối thiểu 8 ký tự"
                       class="w-full rounded-lg border border-gray-300 px-4 py-2.5
                              text-sm outline-none focus:border-indigo-500
                              focus:ring-2 focus:ring-indigo-100">
                <p id="passwordHelp" class="text-xs text-gray-500 mt-1.5">
                    Mật khẩu mới cần có ít nhất 8 ký tự.
                </p>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label for="userRole"
                           class="block text-sm font-semibold text-gray-700 mb-1.5">
                        Vai trò
                    </label>
                    <select id="userRole" name="role" required
                            class="w-full rounded-lg border border-gray-300 bg-white
                                   px-4 py-2.5 text-sm outline-none
                                   focus:border-indigo-500">
                        <option value="BUYER">Người mua</option>
                        <option value="SELLER">Người bán</option>
                        <option value="ADMIN">Quản trị viên</option>
                    </select>
                </div>

                <div id="statusField">
                    <label for="userStatus"
                           class="block text-sm font-semibold text-gray-700 mb-1.5">
                        Trạng thái
                    </label>
                    <select id="userStatus" name="status" required
                            class="w-full rounded-lg border border-gray-300 bg-white
                                   px-4 py-2.5 text-sm outline-none
                                   focus:border-indigo-500">
                        <option value="ACTIVE">Đang hoạt động</option>
                        <option value="LOCKED">Đã khóa</option>
                    </select>
                </div>
            </div>

            <div>
                <label for="userAvatar"
                       class="block text-sm font-semibold text-gray-700 mb-1.5">
                    URL ảnh đại diện
                </label>
                <input id="userAvatar" name="avatarUrl" type="url"
                       placeholder="https://example.com/avatar.jpg"
                       class="w-full rounded-lg border border-gray-300 px-4 py-2.5
                              text-sm outline-none focus:border-indigo-500
                              focus:ring-2 focus:ring-indigo-100">
            </div>

            <div class="flex flex-col-reverse sm:flex-row sm:justify-end gap-3
                        border-t border-gray-100 pt-5">
                <button type="button" onclick="closeUserModal()"
                        class="rounded-lg border border-gray-300 px-5 py-2.5
                               text-sm font-semibold text-gray-700
                               hover:bg-gray-50 transition">
                    Hủy
                </button>

                <button id="userSubmitButton" type="submit"
                        class="rounded-lg bg-indigo-600 px-5 py-2.5 text-sm
                               font-semibold text-white hover:bg-indigo-700 transition">
                    <i class="fas fa-save mr-1.5"></i>
                    Lưu thông tin
                </button>
            </div>
        </form>
    </div>
</div>

<!-- ===================== JAVASCRIPT ===================== -->
<script>
    const userModal = document.getElementById('userModal');
    const userForm = document.getElementById('userForm');

    function openUserModal(mode, button) {
        userForm.reset();

        const actionInput = document.getElementById('userAction');
        const idInput = document.getElementById('userId');
        const title = document.getElementById('userModalTitle');
        const password = document.getElementById('userPassword');
        const passwordRequired = document.getElementById('passwordRequired');
        const passwordHelp = document.getElementById('passwordHelp');
        const submitButton = document.getElementById('userSubmitButton');
        const statusField = document.getElementById('statusField');

        if (mode === 'edit' && button) {
            actionInput.value = 'update';
            idInput.value = button.dataset.id || '';

            document.getElementById('userFullName').value =
                button.dataset.fullName || '';

            document.getElementById('userUsername').value =
                button.dataset.username || '';

            document.getElementById('userEmail').value =
                button.dataset.email || '';

            document.getElementById('userRole').value =
                button.dataset.role || 'BUYER';

            document.getElementById('userStatus').value =
                button.dataset.status || 'ACTIVE';

            document.getElementById('userAvatar').value =
                button.dataset.avatar || '';

            title.textContent = 'Cập nhật người dùng';
            submitButton.innerHTML =
                '<i class="fas fa-save mr-1.5"></i> Lưu thay đổi';

            password.required = false;
            password.value = '';
            passwordRequired.classList.add('hidden');
            passwordHelp.textContent =
                'Để trống nếu không muốn thay đổi mật khẩu.';

            // Username thường được dùng làm định danh đăng nhập.
            // Khóa chỉnh sửa để tránh vô tình thay đổi tài khoản.
            document.getElementById('userUsername').readOnly = true;
            document.getElementById('userUsername').classList.add('bg-gray-100');

            // Không cho sửa trạng thái tại form này.
            // Dùng nút khóa/mở khóa ở bảng để đổi trạng thái.
            statusField.classList.add('hidden');
            document.getElementById('userStatus').disabled = true;
        } else {
            actionInput.value = 'add';
            idInput.value = '';

            title.textContent = 'Thêm người dùng mới';
            submitButton.innerHTML =
                '<i class="fas fa-user-plus mr-1.5"></i> Tạo tài khoản';

            password.required = true;
            passwordRequired.classList.remove('hidden');
            passwordHelp.textContent =
                'Mật khẩu mới cần có ít nhất 8 ký tự.';

            document.getElementById('userUsername').readOnly = false;
            document.getElementById('userUsername').classList.remove('bg-gray-100');

            statusField.classList.remove('hidden');
            document.getElementById('userStatus').disabled = false;
        }

        userModal.classList.remove('hidden');
        userModal.classList.add('flex');
        document.body.classList.add('overflow-hidden');

        setTimeout(function () {
            document.getElementById('userFullName').focus();
        }, 50);
    }

    function closeUserModal() {
        userModal.classList.add('hidden');
        userModal.classList.remove('flex');
        document.body.classList.remove('overflow-hidden');

        document.getElementById('userUsername').readOnly = false;
        document.getElementById('userUsername').classList.remove('bg-gray-100');
        document.getElementById('userStatus').disabled = false;
        document.getElementById('statusField').classList.remove('hidden');
    }

    function confirmUserStatus(form) {
        const id = form.querySelector('[name="userId"]').value;
        return confirm(
            'Bạn có chắc muốn thay đổi trạng thái tài khoản #' + id + '?'
        );
    }

    function confirmDeleteUser(form) {
        const id = form.querySelector('[name="userId"]').value;
        return confirm(
            'Bạn có chắc muốn xóa người dùng #' + id +
            ' khỏi danh sách quản trị?'
        );
    }

    userModal.addEventListener('click', function (event) {
        if (event.target === userModal) {
            closeUserModal();
        }
    });

    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape' && !userModal.classList.contains('hidden')) {
            closeUserModal();
        }
    });

    userForm.addEventListener('submit', function (event) {
        const password = document.getElementById('userPassword');
        const action = document.getElementById('userAction').value;

        if (action === 'add' && password.value.length < 8) {
            event.preventDefault();
            alert('Mật khẩu phải có ít nhất 8 ký tự.');
            password.focus();
        }
    });
</script>
```