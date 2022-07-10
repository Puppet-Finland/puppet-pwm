# frozen_string_literal: true

require 'spec_helper'

describe 'pwm' do
  default_params = { 'tomcat_manager_allow_cidr'    => '192.168.59.0/24',
                     'tomcat_manager_user'          => 'admin',
                     'tomcat_manager_user_password' => 'vagrant',
                     'pwm_download_url'             => 'https://github.com/pwm-project/pwm/releases/download/v2_0_1/pwm-2.0.1.war' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { default_params }

      it { is_expected.to compile }
    end
  end
end
