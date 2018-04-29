library(msdata)
library(neurobase)

res = download_ms_patient("patient01")

files = c(T1 ="T1W.nii.gz", T1POST = "T1WKS.nii.gz", T2 = "T2W.nii.gz", FLAIR = "FLAIR.nii.gz", "Segmentation" = "consensus_gt.nii.gz")

imgs = check_nifti(files)
mask = readnii("brainmask.nii.gz")

imgs = lapply(imgs, mask_img, mask = mask)
dd = dropEmptyImageDimensions(mask, keep_ind=TRUE)
imgs = lapply(imgs, applyEmptyImageDimensions, inds = dd$inds)

imgs = lapply(imgs, function(x) {
  x[ x < 0] =0; 
  x
})
imgs$Segmentation = imgs$Segmentation*1000
imgs$FLAIR = imgs$FLAIR*3
imgs$T2 = imgs$T2/2

n = names(imgs)
n[ n == "Segmentation"] = "Mask"
names(imgs) = n

png("overlay.png", height = 5, width = 10, units = "in", res = 600)
multi_overlay(imgs, text = names(imgs), text.y = 2.5)
dev.off()


png("figure/FLAIR.png", height = 5, width = 5, units = "in", res = 600)
oro.nifti::slice(imgs$FLAIR, z = 135.0)
dev.off()
png("figure/lesion.png", height = 5, width = 5, units = "in", res = 600)
oro.nifti::slice(imgs$Mask, z = 135.0)
dev.off()
