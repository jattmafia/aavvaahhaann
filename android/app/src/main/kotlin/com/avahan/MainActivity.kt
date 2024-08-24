package com.avahan

import android.view.WindowManager.LayoutParams;
import io.flutter.embedding.engine.FlutterEngine
import com.ryanheise.audioservice.AudioServiceFragmentActivity;


class MainActivity: AudioServiceFragmentActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
  window.addFlags(LayoutParams.FLAG_SECURE);
  super.configureFlutterEngine(flutterEngine)
  }
}
