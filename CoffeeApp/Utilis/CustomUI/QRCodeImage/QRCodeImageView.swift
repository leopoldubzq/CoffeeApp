import SwiftUI

struct QRCodeImageView: View {
    
    let qrCodeString: String
    
    init(from qrCodeString: String) {
        self.qrCodeString = qrCodeString
    }
    
    var body: some View {
        QRCodeImage(from: qrCodeString)
            .resizable()
            .interpolation(.none)
            .scaledToFit()
    }
    
    private func QRCodeImage(from string: String) -> Image {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return Image(uiImage: UIImage(cgImage: cgImage))
        }
        let backupImage: UIImage = UIImage(systemName: "qrcode") ?? UIImage()
        return Image(uiImage: backupImage)
    }
}

#Preview {
    QRCodeImageView(from: "123456789")
}
