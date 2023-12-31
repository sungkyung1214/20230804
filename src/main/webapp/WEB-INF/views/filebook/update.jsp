<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>방명록</title>
<link rel="stylesheet" href="resources/css/summernote-lite.css">
<style type="text/css">
	a { text-decoration: none;}
	table{width: 600px; border-collapse:collapse; text-align: center;}
	table,th,td{border: 1px solid black; padding: 3px}
	div{width: 600px; margin:auto; text-align: center;}
	.note-btn-group{width: auto;}
	.note-toolbar{width: auto;}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function() {
		var pwchk = "${pwchk}"
		if(pwchk == "fail"){
			alert("비밀번호 틀림");
			return;
		}
	});
</script>
<script type="text/javascript">
	function save_go(f) {
		f.action="/filebook_edit.do";
		f.submit();
	}
</script>
</head>
<body>
	<div>
		<h2>방명록 : 수정화면</h2>
		<hr />
		<p>[<a href="/guestbook2_list.do">목록으로 이동</a>]</p>
		<form method="post" enctype="multipart/form-data"><!--  비밀번호니까 post로 보호 -->
			<table>
				<tr align="center">
					<td bgcolor="pink">작성자</td>
					<td><input type="text" name="name" size ="20" value="${fvo.name }"/></td>
				</tr>
				<tr align="center">
					<td bgcolor="pink">제  목</td>
					<td><input type="text" name="subject" size ="20" value="${fvo.subject }"/></td>
				</tr>
				<tr align="center">
					<td bgcolor="pink">email</td>
					<td><input type="text" name="email" size ="20" value="${fvo.email}"/></td>
				</tr>
				<tr align="center">
					<td bgcolor="pink">비밀번호</td>
					<td><input type="password" name="pwd" size ="20" /></td>
				</tr>
				<tr align="center">
					<td bgcolor="pink">첨부파일</td>
					<c:choose>
						<c:when test="${empty fvo.f_name }">
							<td><input type="file" name="file"><br><b> 이전 파일 없음</b> </td>
							<input type="hidden" name = "old_f_name" value="">
						</c:when>
						<c:otherwise>
						<td><input type="file" name="file"><br><b> 이전 파일명 (${fvo.f_name })</b> </td>
							<input type="hidden" name = "old_f_name" value="${fvo.f_name }">
						</c:otherwise>
					</c:choose>
				</tr>
				<tr align="center">
					<td colspan="2">
						<textarea rows="10" cols="60" name="content" id="content">${fvo.content}</textarea>
					</td>
				</tr>
				<tfoot>
					<tr align="center">
						<td colspan="2">
							<input type="hidden" value="${fvo.idx }" name="idx">
							<input type="button" value="저장" onclick="save_go(this.form)" />
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="reset" value="취소" />
						</td>
					</tr>
				</tfoot>
			</table>
		</form>
	</div>
    	<script src="resources/js/summernote-lite.js"></script>
    	<script src="resources/js/lang/summernote-ko-KR.js"></script>
    	<script type="text/javascript">
    	$(function(){
    		$('#content').summernote({
    			lang : 'ko-KR',
    			height : 300,
    			focus : true,
    			callbacks : {
    				onImageUpload :  function(files, editor){
    					alert("upload도착");
    					for (var i = 0; i < files.length; i++) {
							sendImage(files[i], editor);
						}
    				}
    			}
			});
    		$("#content").summernote("lineHeight",.7);
    	});
    	function sendImage(file, editor) {
			var frm = new FormData();
			frm.append("s_file",file);
			alert("send도착");
			$.ajax({
				url : "/saveImg.do",
				data : frm,
				type : "post",
				contentType : false,
				processData : false,
				dataType : "json",
			}).done(function(data) {
				var path = data.path;
				var fname = data.fname;
				alert("path : "+path+"\nfname : "+fname);
				$("#content").summernote("editor.insertImage",path+"/"+fname);
			});
		}
    	
    	</script>
</body>
</html>