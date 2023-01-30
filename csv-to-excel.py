#!/usr/bin/env python
# coding=utf-8
import codecs
import csv
import datetime
import time
import xlwt
from xlutils.copy import copy
import pandas as pd
import os
import operator
 
#创建一个空列表，存储当前目录下的CSV文件全称
file_name = []
 
#获取当前目录下的CSV文件名
def name():
    a = os.listdir()
    for j in a:
        if os.path.splitext(j)[1] == '.csv':
            file_name.append(j)
 
#将CSV文件内容导入到csv_storage列表中
def csv_new(storage,name):
    csv_storage = []
    sum = 0
    #显示保存的第几个文件
    file_sum = 0
    #打开读取csv文件
    with codecs.open(storage, 'r', encoding='utf-8') as fp:
        fp_key = csv.reader(fp)
        for csv_key in fp_key:
            csv_reader = csv.DictReader(fp, fieldnames=csv_key)
            for row in csv_reader:
                sum += 1
                #切割为50000个数据一份
                if sum < 50000:
                    csv_dict = dict(row)
                    csv_storage.append(csv_dict)
                else:
                    sum = 0
                    file_sum += 1
                    extract(csv_storage,name,file_sum)
                    csv_storage = []
                    continue
 
#将提取csv_storage列表中有用的数据
def extract(data,name,file_sum):
    csv_storages = []
    #将数据进行筛选
    for x in range(0,len(data)):
        arrays = {'road_name':'','bus_plate':'','time':'','road_type':'','site':'','site_name':'','time_date':''}
        arrays['road_name'] = data[x]['RoadName']
        arrays['bus_plate'] = data[x]['BusPlate']
        #含有时间类型的数据需要进行转换
        arrays['time'] = datetime.datetime.strptime(data[x]['GpsDate'],'%Y-%m-%d %H:%M:%S')
        arrays['road_type'] = data[x]['RoadType']
        arrays['site'] = data[x]['SiteNo']
        arrays['site_name'] = data[x]['SiteName']
        arrays['time_date'] = datetime.datetime.strptime(data[x]['GpsDate'],'%Y-%m-%d %H:%M:%S').date()
        csv_storages.append(arrays)
    export_excel(sorted_x,name,file_sum)
 
 
#将列表文件导出为excel表格文件
def export_excel(export,name,file_sum):
    #将字典列表转换为DataFrame
    pf = pd.DataFrame(list(export))
    #指定字段顺序
    order = ['road_name','bus_plate','time','road_type','site','site_name','time_date']
    try:
        pf = pf[order]
        #将列名替换为中文
        columns_map = {
            'road_name':'路线',
            'bus_plate':'车牌',
            'time':'时间',
            'road_type':'方向',
            'site':'站点',
            'site_name':'站点名称',
            'time_date':'日期'
        }
        pf.rename(columns = columns_map,inplace = True)
        #指定生成的Excel表格名称
        name = name.replace('csv','xlsx')
        name = 'new_' + str(file_sum) + '_' + name
        file_path = pd.ExcelWriter(name)
        #替换空单元格
        pf.fillna(' ',inplace = True)
        #输出
        pf.to_excel(file_path,encoding = 'utf-8',index = False)
        try:
            #保存表格
            file_path.save()
            print("已经保存" + name + "文件")
        except PermissionError:
            print("Excel文件未保存，文件被打开")
    except KeyError:
        print("需要保存的文件内容不同")
 
#主要运行函数
if __name__ == '__main__':
    name()
    print("总共有如下文件:")
    print(file_name)
    for name in file_name:
        csv_new(name,name)
 
# 考虑一下需要添加的功能
