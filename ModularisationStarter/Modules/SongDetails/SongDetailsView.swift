//
//  SongDetailsView.swift
//  ModularisationStarter
//
//  Created by Emre Havan on 13.02.24.
//

import SwiftUI

struct SongDetailsView: View {

    let viewModel: SongDetailsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24.0) {
            VStack(alignment: .leading, spacing: 8.0) {
                Text("ms_song_details_lyrics".localised)
                    .font(.title2)
                Text(viewModel.lyrics())
            }
            VStack(alignment: .leading, spacing: 8.0) {
                Text("ms_song_details_artist_info".localised)
                    .font(.title2)
                HStack {
                    Text(viewModel.artistName())
                    Button(action: {
                        viewModel.didTapGoToArtist()
                    }, label: {
                        Text("ms_song_details_go_to_artist_cta".localised)
                    })
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SongDetailsView(
        viewModel: .init(
            song: .init(
                id: "1",
                name: "Test Song",
                artistName: "Test Artist",
                artistIdentifier: "1",
                lyrics: "Test Song Lyrics"
            ),
            analyticsTracker: AnalyticsEventTrackerMock(),
            onGoToArtistTapped: { _ in }
        )
    )
}
