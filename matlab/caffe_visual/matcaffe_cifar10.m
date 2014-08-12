function [res, layers] = matcaffe_cifar10( im, model_def_file, model_file ,use_gpu)
% scores = matcaffe_demo(im, use_gpu)
%
% Demo of the matlab wrapper using the ILSVRC network.
%
% input
%   im       color image as uint8 HxWx3
%   use_gpu  1 to use the GPU, 0 to use the CPU
%
% output
%   scores   1000-dimensional ILSVRC score vector
%
% You may need to do the following before you start matlab:
%  $ export LD_LIBRARY_PATH=/opt/intel/mkl/lib/intel64:/usr/local/cuda-5.5/lib64
%  $ export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
% Or the equivalent based on where things are installed on your system
%
% Usage:
%  im = imread('../../examples/images/cat.jpg');
%  scores = matcaffe_demo(im, 1);
%  [score, class] = max(scores);
% 
%  model_def_file = '../../examples/cifar10/cifar10_full.prototxt';
%  model_file = './cifar10_full_iter_70000';
if nargin<2
    model_def_file = '../../examples/cifar10/cifar10_full.prototxt';
end
if nargin<3
    model_file = './cifar10_full_iter_70000';
end
if nargin<4
    use_gpu=0;
end

% init caffe network (spews logging info)
if caffe('is_initialized') == 0

  if exist(model_file, 'file') == 0
    % NOTE: you'll have to get the pre-trained ILSVRC network
    error('You need a network model file');
  end
  caffe('init', model_def_file, model_file);
end

% set to use GPU or CPU
if exist('use_gpu', 'var') && use_gpu
  caffe('set_mode_gpu');
else
  caffe('set_mode_cpu');
end

% put into test mode
caffe('set_phase_test');

% you can also get network weights by calling
layers = caffe('get_weights');

% prepare oversampled input
tic;
input_data = {im};
toc;

% do forward pass to get scores
tic;
res = caffe('forward', input_data);
toc;

% average output scores
% scores = reshape(scores{1}, [1000 10]);
% scores = mean(scores, 2);

