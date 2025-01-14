if [ $# -lt 2 ]; then
  echo 1>&2 "$0: not enough arguments"
  exit 2
elif [ $# -gt 2 ]; then
  echo 1>&2 "$0: too many arguments"
  exit 2
fi

CUDA_VISIBLE_DEVICES=$1 python scripts/train.py \
--training_mode validation \
--dataroot $2 \
--dataset_type flyingthings3d \
--num_workers 8 --N_renders_override 2000 \
--scene_channels dualpix_mono --light_attenuation_factor 1.00 --seed 42 \
--f_number 4 --focal_length_mm 50 --in_focus_dist_mm 400 --pixel_pitch_um 10.72 \
--max_defocus_blur_size_px 40 --num_depth_planes 21 --rendering_algorithm ikoma-modified \
--readout_noise_level 0.01 --photon_count_level 10000 --crop_renders_for_valid_convolution \
--analytical_deconv_step None --model_type resunet_ppm --model_output defocus aif \
--channel_dim 64 --normalization bn --final_layer_activation none \
--batch_size 8 --num_epochs 80 --lr_model 0.0001 --scheduler cosine \
--defocus_loss l1 grad --aif_loss l1 grad --wt_defocus_loss 1 --wt_aif_loss 1 \
--depth_metric rmse absrel mae delta1 --aif_metric psnr ssim lpips \
--save_freq 10 --print_freq 100 --expt_savedir ../ --expt_name testing_new_repo_codedDP \
--psf_data_file blur_kernels_simulated_pixel4_nocode.mat \
--initial_mask_fpath ./assets/cads_ckpt_e79.png \
--initial_mask_alpha 10 --lr_mask 0.00 --freeze_mask --save_renders \
--load_wts_file ./assets/cads_ckpt_e79.pth
