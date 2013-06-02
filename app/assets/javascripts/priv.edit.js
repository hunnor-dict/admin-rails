var formEditor;
var transEditor;

function adjustHeight() {
	if ($(window).height() < 850) {
		formEditor.setSize(null, 120);
	} else {
		formEditor.setSize(null, 300);
	}
}

function initForm() {
	formEditor = CodeMirror.fromTextArea(document.getElementById("forms"), {
		mode: "application/xml",
		lineNumbers: true,
		lineWrapping: true,
		onCursorActivity: function() {
			formEditor.setLineClass(hlLine, null, null);
			hlLine = formEditor.setLineClass(formEditor.getCursor().line, null, "activeline");
		}
	});
	var hlLine = formEditor.setLineClass(0, "activeline");
	adjustHeight();
}
function initTrans() {
	transEditor = CodeMirror.fromTextArea(document.getElementById("trans"), {
		mode: "application/xml",
		lineNumbers: true,
		lineWrapping: true,
		onCursorActivity: function() {
			transEditor.setLineClass(hlLine, null, null);
			hlLine = transEditor.setLineClass(transEditor.getCursor().line, null, "activeline");
		}
	});
	var hlLine = transEditor.setLineClass(0, "activeline");
}
function insertTag(tag) {
	insert_string = '';
	if (tag == 'senseGrp') {
		insert_string = '<senseGrp>\n  <sense>\n    <trans></trans>\n  </sense>\n</senseGrp>\n';
	}
	if (tag == 'sense') {
		insert_string = '  <sense>\n    <trans></trans>\n  </sense>\n';
	}
	if (tag == 'trans') {
		insert_string = '    <trans></trans>\n';
	}
	if (tag == 'lbl') {
		insert_string = '    <lbl></lbl>\n';
	}
	if (tag == 'eg') {
		insert_string = '    <eg>\n      <q></q>\n      <trans></trans>\n    </eg>\n';
	}
	transEditor.replaceRange(insert_string, {line:transEditor.getCursor().line,ch:0});
}

function saveEntry() {
	$("#entry-submit").attr("disabled", true);
	$.ajaxSetup({
		beforeSend: function(xhr) {
			xhr.setRequestHeader('X-CSRF-Token', $("meta[name='csrf-token']").attr('content'));
		}
	});
	var entryURL = "/priv/save";
	var entryId = $("#id").val();
	var entryLang = $("#entrylang").val();
	$.post(entryURL, {
		entrylang: $("#entrylang").val(),
		id: $("#id").val(),
		entry: $("#entry").val(),
		pos: $("#pos").val(),
		forms: formEditor.getValue(),
		trans: transEditor.getValue(),
		status: $("#status").val()
		}, function(data) {
			$("#priv-edit-results").html(data);
			$("#entry-submit").removeAttr("disabled");
			if (entryId == "N") {
				var newId = $("#addition").val();
				if (newId != "" && newId != null) {
					loadEntry(entryLang, newId, "");
				}
			}
		}
	);
}
function deleteEntry() {
	if (confirm('Biztos?')) {
		$.ajaxSetup({
			beforeSend: function(xhr) {
				xhr.setRequestHeader('X-CSRF-Token', $("meta[name='csrf-token']").attr('content'));
			}
		});
		var entryURL = "/priv/delete";
		$.post(entryURL, {
			entrylang: $("#entrylang").val(),
			id: $("#id").val()
			}, function(data) {
				$("#priv-edit-results").html(data);
				loadEntry($("#entrylang").val(), "N", "");
			}
		);
	}
}

