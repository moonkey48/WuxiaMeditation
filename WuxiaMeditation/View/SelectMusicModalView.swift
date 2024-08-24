//
//  SelectMusicModalView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/11/24.
//

import SwiftUI

struct SelectMusicModalView: View {
    @AppStorage("selectedMusic") var selectedMusic: String = "Somnolent_TheTides"
    var body: some View {
        List(AudioPlayManager.musicList, id: \.self) { musicName in
            Button {
                selectedMusic = musicName
                AudioPlayManager().playSound(sound: musicName)
            } label: {
                Text(musicName)
            }
        }
    }
}

#Preview {
    SelectMusicModalView()
}
