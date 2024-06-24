# UTIQ Loader iOS WebView

The webview should be configured like this, where the **consentHandler** is the contract that the webview will call in iOS, It can be anything but **consentHandler** is just an example.

```
let contentController = self.webView.configuration.userContentController
contentController.add(self, name: "consentHandler")
```

The JS will pass a value using the contract keyword, in our case **consentHandler** followed by the function **postMessage**, and pass the value we want to post iOS.

```
if (
            window.webkit &&
              window.webkit.messageHandlers &&
            window.webkit.messageHandlers.consentHandler
          ) {
              window.webkit.messageHandlers.consentHandler.postMessage({
                isConsentGranted: isConsentGranted,
              });
            console.log('Webkit message called');
          } else {
              console.warn('No Webkit available in the window object');
          }
```


The iOS View should conform to this protocol `WKScriptMessageHandler` and implement this function to observe changes posted from the webview.

```
func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }
        print("JS Message", dict)
        //
        guard let isConsentGranted = dict["isConsentGranted"] else {
            return
        }
}
```

Code snippet to update a JS element:

```
let script = "document.getElementById('mobile-anchor').innerText = \"\(isConsentGranted)\""
webView.evaluateJavaScript(script) { (result, error) in
    if let result = result {
         print("Label is updated with message: \(result)")
    } else if let error = error {
         print("An error occurred: \(error)")
     }
}
```