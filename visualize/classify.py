import numpy as np
import matplotlib

matplotlib.use('Agg')
import matplotlib.pyplot as plt

#%matplotlib inline

# Make sure that caffe is on the python path:
caffe_root = '../'  # this file is expected to be in {caffe_root}/examples
import sys
sys.settrace
sys.path.insert(0, caffe_root + 'python')

import caffe

# Set the right path to your model definition file, pretrained model weights,
# and the image you would like to classify.
MODEL_FILE = 'imagenet/imagenet_deploy.prototxt'
PRETRAINED = 'imagenet/caffe_reference_imagenet_model'
IMAGE_FILE = 'images/fish-bike.jpg'

net = caffe.Classifier(MODEL_FILE, PRETRAINED,
                       mean=np.load(caffe_root + 'python/caffe/imagenet/ilsvrc_2012_mean.npy'),
                       channel_swap=(2,1,0),
                       raw_scale=255,
                       image_dims=(256, 256))

net.set_phase_test()
net.set_mode_cpu()

input_image = caffe.io.load_image(IMAGE_FILE)

plt.imshow(input_image)
plt.savefig('cata.jpg')

plt.clf()
prediction = net.predict([input_image])  # predict takes any number of images, and formats them for the Caffe net automatically
print 'prediction shape:', prediction[0].shape
plt.plot(prediction[0])
print 'predicted class:', prediction[0].argmax()
plt.savefig('prediction.jpg')
