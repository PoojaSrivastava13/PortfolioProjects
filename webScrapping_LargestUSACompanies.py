#!/usr/bin/env python
# coding: utf-8

# In[3]:


#Fetching html page

from bs4 import BeautifulSoup
import requests

path = 'https://www.scrapethissite.com/pages/simple/'
page = requests.get(path)
soup = BeautifulSoup(page.text, 'html')


# In[4]:


soup.find('h3', class_='country-name').text.strip()


# In[5]:


from bs4 import BeautifulSoup
import requests

url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'
page = requests.get(url)
soup = BeautifulSoup(page.text, 'html')


# In[6]:


table = soup.find_all('table')[1]


# In[7]:


all_titles = table.find_all('th')
print(all_titles)


# In[8]:


formatted_title = [titles.text.strip() for titles in all_titles]
print(formatted_title)


# In[9]:


import pandas as pd

df = pd.DataFrame(columns=formatted_title)
df


# In[10]:


column_data = table.find_all('tr')


# In[177]:


for rows in column_data[1:]:
    all_values = rows.find_all('td')
    formatted_values = [values.text.strip() for values in all_values]
    #print(formatted_values)
    length = len(df)
    #print(length)
    df.loc[length] = formatted_values


# In[178]:


df


# In[181]:


df.to_csv('/Users/praveenmadhogaria/Desktop/LargestCompaniesUSA.csv', index=False)


# In[207]:


import pandas as pd

df = pd.read_excel('/Users/praveenmadhogaria/Desktop/Pandas_Tutorial/world_population_excel_workbook.xlsx')
df


# In[239]:


df2=df.set_index('Country')
df2


# In[248]:


df2.filter(like = 'Y', axis=0)


# In[257]:


df


# In[343]:


pd.set_option('display.max_rows',400)
pd.set_option('display.max_columns',30)


# In[319]:


dfCountry=df.set_index("Country")
dfCountry


# In[345]:


print(pd.options.display.max_columns)


# df.info()

# In[354]:


df


# In[440]:


sample_dict={'one':pd.Series([10,20,30,40],index=[1,2,3,4]),'two':pd.Series([101,202,303,404],index=[1,2,3,4])}
sample_df=pd.DataFrame(sample_df)
sample_df


# In[329]:


df[df.Country.str.contains('United')]


# In[333]:


df[df.Country.str.startswith('I')]


# In[342]:


print(df.to_string())


# In[ ]:





# In[ ]:




