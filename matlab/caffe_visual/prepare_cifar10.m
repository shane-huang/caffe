% ------------------------------------------------------------------------
function [images,label]= prepare_cifar10
% ------------------------------------------------------------------------
path='./cifar10/';
% files=dir([path,'/data*.bin']);
% 
% X=[];
% % tbatch=zeros(3073,10001);
% for i=1:length(files)
%     fid=fopen([path,files(i).name],'rb');
%     tbatch=fread(fid,[3073,10000],'uint8');
%     X=[X,tbatch];
%     fclose(fid);
% end
% label=X(1,:);
% X(1,:)=[];

% 
files=dir([path,'/test*.bin']);
X=[];
for i=1:length(files)
    fid=fopen([path,files(i).name],'rb');
    tbatch=fread(fid,[3073,10000],'uint8');
    X=[X,tbatch];
    fclose(fid);
end
label=X(1,:);
X(1,:)=[];


im=single(reshape(bsxfun(@minus,X,mean(X,2)),[32,32,3,size(X,2)]));
% images=im;
images=im(:,:,:,:);
% images=permute(images,[2,1,3,4]);

end