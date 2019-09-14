# encoding: utf-8

require "serverspec"
require "docker"

Docker.validate_version!

def load_docker_image
    docker_username = ENV['DOCKER_USERNAME']
    package_name    = ENV['PACKAGE_NAME']
    package_version = ENV['PACKAGE_VERSION']
    image_name      = ENV['IMAGE_NAME']

    # check for package version major usage
    if package_version.match(/(\d+).x/)
        package_version = package_version.match(/(\d+).x/)[1]
    end

    image = Docker::Image.get(
      "#{docker_username}/#{package_name}:#{package_version}-#{image_name}"
    )
    set :backend, :docker
    set :docker_image, image.id
    set :docker_container_create_options, { 'Entrypoint' => ['/bin/bash'] }
    # set :docker_container_create_options, { 'Cmd' => ['bash'] }
    return image
end

def os_version
  command("cat /etc/*-release").stdout
end

def sys_user
  command("whoami").stdout.strip
end
