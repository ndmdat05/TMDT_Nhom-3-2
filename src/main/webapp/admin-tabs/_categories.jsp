
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
    <div>
        <h1 class="text-2xl font-bold text-gray-900 mb-1">
            Quản lý danh mục
        </h1>
        <p class="text-sm text-gray-500">
            Thêm, sửa và xóa các thể loại truyện trên sàn.
        </p>
    </div>
</div>

<c:if test="${not empty sessionScope.adminSuccess}">
    <div class="mb-4 p-4 bg-emerald-50 border border-emerald-200
                text-emerald-800 rounded-lg text-sm">
        <c:out value="${sessionScope.adminSuccess}"/>
    </div>
    <c:remove var="adminSuccess" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.adminError}">
    <div class="mb-4 p-4 bg-red-50 border border-red-200
                text-red-800 rounded-lg text-sm">
        <c:out value="${sessionScope.adminError}"/>
    </div>
    <c:remove var="adminError" scope="session"/>
</c:if>

<!-- Thêm danh mục -->
<div class="bg-white border border-gray-200 rounded-xl p-5 mb-6">
    <h2 class="font-bold text-gray-900 mb-3">Thêm danh mục mới</h2>

    <form method="post" action="${ctx}/admin/manage"
          class="flex flex-col sm:flex-row gap-3">
        <input type="hidden" name="tab" value="categories">
        <input type="hidden" name="action" value="add">

        <input type="text" name="categoryName" required maxlength="255"
               placeholder="Nhập tên danh mục..."
               class="flex-1 border border-gray-300 rounded-lg px-4 py-2
                      outline-none focus:ring-2 focus:ring-indigo-100
                      focus:border-indigo-500">

        <button type="submit"
                class="px-4 py-2 rounded-lg bg-indigo-600 text-white
                       font-semibold hover:bg-indigo-700">
            <i class="fas fa-plus mr-1"></i> Thêm danh mục
        </button>
    </form>
</div>

<!-- Danh sách danh mục -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="p-5 border-b border-gray-200">
        <h2 class="font-bold text-gray-900">Danh sách danh mục</h2>
        <p class="text-sm text-gray-500 mt-1">
            Số lượng truyện được tính từ dữ liệu trong database.
        </p>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left text-sm">
            <thead class="bg-gray-50 text-gray-600 text-xs uppercase">
            <tr>
                <th class="px-5 py-4">ID</th>
                <th class="px-5 py-4">Tên danh mục</th>
                <th class="px-5 py-4">Số lượng truyện</th>
                <th class="px-5 py-4">Trạng thái</th>
                <th class="px-5 py-4 text-right">Thao tác</th>
            </tr>
            </thead>

            <tbody class="divide-y divide-gray-100">
            <c:forEach var="cat" items="${categoryList}">
                <tr class="hover:bg-gray-50">
                    <td class="px-5 py-4 font-semibold text-gray-700">
                        #<c:out value="${cat.id}"/>
                    </td>

                    <td class="px-5 py-4">
                        <form method="post" action="${ctx}/admin/manage"
                              class="flex flex-col sm:flex-row gap-2">
                            <input type="hidden" name="tab" value="categories">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="categoryId"
                                   value="${cat.id}">

                            <input type="text" name="categoryName"
                                   value="<c:out value='${cat.name}'/>"
                                   maxlength="255" required
                                   class="min-w-0 flex-1 border border-gray-200
                                              rounded-md px-2 py-1.5
                                              focus:border-indigo-500 outline-none">

                            <button type="submit"
                                    class="text-indigo-600 hover:text-indigo-800"
                                    title="Lưu tên danh mục">
                                <i class="fas fa-save"></i>
                            </button>
                        </form>
                    </td>

                    <td class="px-5 py-4 text-gray-600">
                        <c:out value="${cat.productCount}"/>
                    </td>

                    <td class="px-5 py-4">
                        <c:choose>
                            <c:when test="${cat.productCount gt 0}">
                                    <span class="px-2 py-1 rounded bg-emerald-50
                                                 text-emerald-700 text-xs font-semibold">
                                        Đang sử dụng
                                    </span>
                            </c:when>
                            <c:otherwise>
                                    <span class="px-2 py-1 rounded bg-gray-100
                                                 text-gray-600 text-xs font-semibold">
                                        Chưa có truyện
                                    </span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td class="px-5 py-4 text-right">
                        <form method="post" action="${ctx}/admin/manage"
                              class="inline"
                              onsubmit="return confirm('Bạn có chắc muốn xóa danh mục này?');">
                            <input type="hidden" name="tab" value="categories">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="categoryId"
                                   value="${cat.id}">

                            <button type="submit"
                                    class="text-red-600 hover:text-red-800"
                                    title="Xóa danh mục">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty categoryList}">
                <tr>
                    <td colspan="5"
                        class="px-5 py-10 text-center text-gray-500">
                        Chưa có danh mục nào trong cơ sở dữ liệu.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
