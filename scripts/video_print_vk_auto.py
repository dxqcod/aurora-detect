#!/usr/bin/python

import requests
import json
import datetime

# Токен доступа ВК (в текущей версии он захардкожен в файле)
# Рekomendуется вынести его в переменную окружения или config/.env, но сейчас оставил как было.
token = 'VK_TOKEN'

# Пример получения токена:
# https://oauth.vk.com/authorize?client_id=5490057&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends&response_type=token&v=5.52
# client_id — id приложения
# scope — права (photo, video, ...)
# (см. документацию VK API для актуальных параметров)

# Параметры загрузки (группа, альбом, публикация на стене)
group_id = '168611621'
album_id = '1'
wallp = '1'

# Имя и путь файла, который будем загружать (по сегодняшней дате)
upload_file = datetime.datetime.today().strftime("/media/pi/Transcend/time/time_video/timelaps%m-%d.avi")
upload_file_name = datetime.datetime.today().strftime("timelaps%m-%d.avi")

def write_json(data, filename):
    """Вспомогательная функция: записать объект в JSON (для отладки)."""
    with open(filename, 'w') as file:
        json.dump(data, file, indent=2, ensure_ascii=False)

def get_upload_server():
    """
    Запрашиваем у VK сервер для загрузки видео (video.save).
    Возвращается upload_url — адрес, на который нужно залить файл.
    """
    r = requests.get('https://api.vk.com/method/video.save', params={
        'access_token': token,
        'name': upload_file_name,
        'album_id': album_id,
        'group_id': group_id,
        'wallpost': wallp,
        'v': 5.8
    }).json()
    # При отладке можно сохранить ответ: write_json(r, 'upload_server.json')
    return r['response']['upload_url']

def main():
    """Основная функция: получает upload_url и отправляет туда файл."""
    upload_url = get_upload_server()

    print(upload_file)
    file = {'video_file': open(upload_file, 'rb')}
    ur = requests.post(upload_url, files=file).json()
    # При отладке можно сохранить ответ: write_json(ur, 'upload_video.json')

    # В старых реализациях для фото использовался дополнительный метод photos.save.
    # Для видео это обычно не требуется — VK возвращает данные о загруженном видео.
    # Примеры вызовов сохранены ниже (закомментированы).
    #result = requests.get('https://api.vk.com/method/photos.save', params={
    #    'access_token': token,
    #    'album_id': ur['aid'],
    #    'group_id': ur['gid'],
    #    'server': ur['server'],
    #    'photos_list': ur['photos_list'],
    #    'hash': ur['hash'],
    #    'v': 5.8
    #}).json()
    #print(result)

if __name__ == '__main__':
    main()

