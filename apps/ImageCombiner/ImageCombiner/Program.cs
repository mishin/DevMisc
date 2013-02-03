using System;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Windows.Forms;

namespace ImageCombiner
{
    public enum JoinOrientation
    {
        Horizontal,
        Vertical,
    }

    class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            var monitorCount = 3;
            var imageFilterDeclaration = "Image Files|*.jpg;*.jpeg;*.png;*.bmp;*.gif;*.ico;*.wdp;*.tiff";
            var orientation = JoinOrientation.Vertical;

            var filePaths = new string[monitorCount];

            for (int i = 0; i < filePaths.Length; i++)
            {
                var fileDialog = new OpenFileDialog()
                {
                    Title = String.Format("Choose file #{0}", i + 1),
                    CheckFileExists = true,
                    Multiselect = false,
                    Filter = imageFilterDeclaration,
                };
                var dialogResult = fileDialog.ShowDialog();
                if (dialogResult != DialogResult.OK)
                {
                    return;
                }

                filePaths[i] = fileDialog.FileName;
            }

            var images = filePaths
                .Select(x => new System.Drawing.Bitmap(x))
                .ToArray();

            var outputImage = orientation == JoinOrientation.Horizontal
                ? CombineImagesHorizontally(images)
                : CombineImagesVertically(images);

            var saveFileDialog = new SaveFileDialog()
            {
                Filter = imageFilterDeclaration,
            };
            if (saveFileDialog.ShowDialog() == DialogResult.OK)
            {
                outputImage.Save(saveFileDialog.FileName);
                Console.WriteLine("Saved file {0}", saveFileDialog.FileName);
            }
        }

        private static Bitmap CombineImagesHorizontally(Bitmap[] images)
        {
            if (images.All(x => x.Height == images[0].Height) == false)
            {
                throw new InvalidOperationException("all images must have the same height");
            }

            var outputHeight = images[0].Height;
            var outputWidth = images.Sum(x => x.Width);

            var outputImage = new Bitmap(outputWidth, outputHeight);

            using (var g = Graphics.FromImage(outputImage))
            {
                //set background color
                g.Clear(System.Drawing.Color.Black);

                //go through each image and draw it on the output image
                int offset = 0;
                foreach (System.Drawing.Bitmap image in images)
                {
                    g.DrawImage(image,
                        new System.Drawing.Rectangle(offset, 0, image.Width, image.Height)
                    );
                    offset += image.Width;
                }
            }
            return outputImage;
        }

        private static Bitmap CombineImagesVertically(Bitmap[] images)
        {
            if (images.All(x => x.Width == images[0].Width) == false)
            {
                throw new InvalidOperationException("all images must have the same width");
            }

            var outputHeight = images.Sum(x => x.Height);
            var outputWidth = images[0].Width;

            var outputImage = new Bitmap(outputWidth, outputHeight);

            using (var g = Graphics.FromImage(outputImage))
            {
                //set background color
                g.Clear(System.Drawing.Color.Black);

                //go through each image and draw it on the output image
                int offset = 0;
                foreach (System.Drawing.Bitmap image in images)
                {
                    g.DrawImage(image,
                        new System.Drawing.Rectangle(0, offset, image.Width, image.Height)
                    );
                    offset += image.Height;
                }
            }
            return outputImage;
        }
    }
}
