from django.http import HttpResponse
from IotServer.pyrebase_settings import firebase_storage
from django.template import loader


# Create your views here.

def get_firebase_images(request):
    # files = list(firebase_storage.child('police29/').list_files())[-4:]
    # count = 1
    # for file in files:
    #     file.download_to_filename('cloud\\test' + str(count) + '.jpg')
    #     count += 1
    context = {
    }
    template = loader.get_template('index.html')
    return HttpResponse(template.render(context, request))
