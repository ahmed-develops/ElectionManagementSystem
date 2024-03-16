from django.http import HttpResponse
from django.template import loader

def landing(request):
    template = loader.get_template('landing_page.html')
    return HttpResponse(template.render())