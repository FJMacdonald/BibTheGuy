//
//  ContentView.swift
//  BibTheGuy
//
//  Created by Francesca MACDONALD on 2023-08-22.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateImage = true
    @State private var selectedPhoto: PhotosPickerItem!
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(animateImage ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundFile: "punchSound")
                    animateImage = false
                    withAnimation(.spring(
                        response: 0.3, dampingFraction: 0.3)) {
                            animateImage = true
                        }
                }
            
            Spacer()
            
            
            Spacer()
            PhotosPicker(selection: $selectedPhoto, matching:
                    .images, preferredItemEncoding: .automatic) {
                        Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
                    }
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        bipImage = Image(uiImage: uiImage)
                                    }
                                }
                            } catch {
                                print("😡 ERROR: loading failed \(error.localizedDescription)")
                            }
                        }
                    }
        }
    }
    
    func playSound(soundFile: String) {
        guard let soundFile = NSDataAsset(name: soundFile) else {
            print("😡 ERROR: could not read sound file")
                  return
        }
        do {
            
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: could not create audioPlayer")
            return
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
