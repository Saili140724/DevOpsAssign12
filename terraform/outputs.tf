output "swarm_manager_public_ip" {
  value = aws_instance.manager.public_ip
}

output "swarm_worker_a_public_ip" {
  value = aws_instance.worker_a.public_ip
}

output "swarm_worker_b_public_ip" {
  value = aws_instance.worker_b.public_ip
}
