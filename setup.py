# -*- coding: utf-8 -*-

from setuptools import setup, find_packages


with open('README.rst') as f:
    readme = f.read()

with open('LICENSE') as f:
    license = f.read()

setup(
    name='stride',
    version='1.0.0',
    description='Python bindings to STRIDE secondary structure analysis',
    long_description=readme,
    author='Richard J. Gowers',
    author_email='richardjgowers@gmail.com',
    url='https://github.com/MDAnalysis/stride',
    license=license,
    packages=find_packages(exclude=('tests', 'doc'))
)
