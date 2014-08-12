% model_def_file = '../../examples/imagenet/imagenet_deploy.prototxt';
% model_file = '../../examples/imagenet/caffe_reference_imagenet_model';
 batchsize=1000;%This should be corresponded to the number in prototxt file
%  model_def_file = '../../examples/cifar10/cifar10_full.prototxt';
%  model_file = './cifar10_full_iter_70000';
 model_def_file = './cifar10_full_proto_l1_64_l2_128.prototxt';
 model_file = './cifar10_full_64_l1_transform_iter_100000';

 [im,label]=prepare_cifar10;
  [res,layers]= matcaffe_cifar10(im(:,:,:,1:batchsize),model_def_file,model_file,0);
 
 output=shiftdim(res(end).responses{1},2);
 [score,class]=max(output);
 class=class-1;
 accuracy=sum(class==label(1:batchsize))/batchsize;
 figure(100),imshow(gendisp(permute(res(1).responses{1}(:,:,:,1:100),[2,1,3,4])));
 
 figure(101),
 subplot(2,2,1),imshow(gendisp(permute(layers(1).weights{1},[2,1,3,4])));
%  for i=1:100
%  figure(101),
%  subplot(2,2,2),imshow(gendisp(permute(res(2).responses{1}(:,:,:,i),[2,1,3,4])));
%  subplot(2,2,3),imshow(gendisp(permute(res(6).responses{1}(:,:,:,i),[2,1,3,4])));
%  subplot(2,2,4),imshow(gendisp(permute(res(10).responses{1}(:,:,:,i),[2,1,3,4])));
%  pause;
%  end
input=res(1).responses{1};
conv3=permute(res(13).responses{1},[2,1,3,4]);
input=permute(input,[2,1,3,4]);

conv3sum=shiftdim(sum(sum(conv3,2),1),2);
for i=1:size(conv3sum,1);
    [val,idx]=sort(conv3sum(i,:),'descend');
    figure(11),imshow(gendisp(input(:,:,:,idx(1:36))))
    pause;
end
input=zeros([43,43,3,batchsize]);

conv2=permute(res(8).responses{1},[2,1,3,4]);
input(6:37,6:37,:,:)=permute(res(1).responses{1},[2,1,3,4]);
dispsum=zeros(12,12,3,size(conv2,3));
numdisp=64;
for i=1:size(conv2,3);
    [maxres,r]=max(conv2(:,:,i,:),[],1);
    [maxres2,c]=max(maxres,[],2);
    
    [val,idx]=sort(maxres2,'descend');
    dispfea=zeros(12,12,3,numdisp);
    for j=1:numdisp
        cc=c(idx(j));
        rr=r(1,cc,1,idx(j));
%         dispfea(:,:,:,j)=input(2*rr-1:2*rr+10,2*cc-1:2*cc+10,:,idx(j));
        dispfea(:,:,:,j)=input(3*rr-1:3*rr+10,3*cc-1:3*cc+10,:,idx(j));
    end
    dispsum(:,:,:,i)=sum(dispfea,4);
    figure(11),
    subplot(1,2,1),imshow(gendisp(dispfea))
    subplot(1,2,2),imshow(gendisp(dispsum))
    pause;
end


%  figure(101),imshow(gendisp(layers(1).weights{1},4,0));
%  figure(102),imshow(gendisp(reshape(layers(2).weights{1},[5,5,1,32*32]),32,0));
%  figure(103),imshow(gendisp(reshape(layers(3).weights{1},[5,5,1,32*64]),32,0));