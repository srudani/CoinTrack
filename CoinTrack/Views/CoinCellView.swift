//
//  CoinCellView.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-11.
//

import SwiftUI
import CachedAsyncImage

struct CoinCellView: View {
    let coin: CoinModel
   
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            rightColumn
        }
        .font(.subheadline)
    }
}

struct CoinCellView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CoinCellView(coin: previewHelper.coin)
                .previewLayout(.sizeThatFits)

            CoinCellView(coin: previewHelper.coin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CoinCellView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.black)
                .frame(minWidth: 30)
            
            CachedAsyncImage(url: URL(string: coin.image), urlCache: .imageCache) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .failure:
                    Image(systemName: "photo")
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 30, maxHeight: 30)
                @unknown default:
                    Image(systemName: "photo")
                }
            }
           
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.black)
        }
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWithNumberOfDecimals(6))
                .bold()
                .foregroundColor(Color.black)
            Text(coin.priceChangePercentage24H?.asPercentString ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0 >= 0) ?
                    Color.green :
                    Color.red
                )
        }
    }
}
