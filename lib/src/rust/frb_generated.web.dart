// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.34.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/compute.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'helper.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  Correctness dco_decode_correctness(dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  List<RustLetterBox> dco_decode_list_rust_letter_box(dynamic raw);

  @protected
  List<RustLetterBoxArray5> dco_decode_list_rust_letter_box_array_5(
      dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  RustLetterBox dco_decode_rust_letter_box(dynamic raw);

  @protected
  RustLetterBoxArray5 dco_decode_rust_letter_box_array_5(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  Correctness sse_decode_correctness(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  List<RustLetterBox> sse_decode_list_rust_letter_box(
      SseDeserializer deserializer);

  @protected
  List<RustLetterBoxArray5> sse_decode_list_rust_letter_box_array_5(
      SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  RustLetterBox sse_decode_rust_letter_box(SseDeserializer deserializer);

  @protected
  RustLetterBoxArray5 sse_decode_rust_letter_box_array_5(
      SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_correctness(Correctness self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_rust_letter_box(
      List<RustLetterBox> self, SseSerializer serializer);

  @protected
  void sse_encode_list_rust_letter_box_array_5(
      List<RustLetterBoxArray5> self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void sse_encode_rust_letter_box(RustLetterBox self, SseSerializer serializer);

  @protected
  void sse_encode_rust_letter_box_array_5(
      RustLetterBoxArray5 self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
class RustLibWasmModule implements WasmModule {
  @override
  external Object /* Promise */ call([String? moduleName]);

  @override
  external RustLibWasmModule bind(dynamic thisArg, String moduleName);
}
