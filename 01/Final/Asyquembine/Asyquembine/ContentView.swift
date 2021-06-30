/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView {
  private let syncIterator = EncodedModelIterator()

  @State private var publishedModel: Model?
}

// MARK: - private
private extension ContentView {
  struct IteratorView: View {
    let title: String
    let syncIterator: EncodedModelIterator
    @Binding var model: Model?

    var body: some View {
      VStack(spacing: 12) {
        Text(title)
          .font(.title)
          .bold()
          .foregroundColor(.secondary)

        Text("Iteration: \( model.map { String($0.int) } ?? "nil")")
          .font(.title)

        HStack {
          Button(action: syncIterator.resume) {
            Label("Resume", systemImage: "play")
          }
          Button(action: syncIterator.stop) {
            Label("Stop", systemImage: "stop")
          }
          .tint(.red)
        }

        Button {
          _ = syncIterator.next()
        } label: {
          Label("Iterate", systemImage: "arrow.clockwise")
        }
      }
      .font(.title3)
      .buttonStyle(.bordered)
      .padding()
    }
  }
}

// MARK: - View
extension ContentView: View {
  var body: some View {
    VStack {
      IteratorView(
        title: "Combine",
        syncIterator: syncIterator,
        model: $publishedModel
      )
        .onReceive(
          syncIterator.publisher
            .decode(type: Model.self, decoder: JSONDecoder())
            .map { $0 }
            .replaceError(with: nil)
        ) {
          publishedModel = $0
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
