# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = var.enable_http2
  idle_timeout               = var.idle_timeout
  ip_address_type            = var.enable_ipv6 ? "dualstack" : "ipv4"

  tags = {
    Name = "${var.project}-alb-${var.environment}"
  }
}

# ターゲットグループ（HTTP）
resource "aws_lb_target_group" "http" {
  name     = "${var.project}-tg-http-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  deregistration_delay = 30

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  tags = {
    Name = "${var.project}-tg-http-${var.environment}"
  }
}

# HTTPSリスナー（証明書がある場合のみ）
resource "aws_lb_listener" "https" {
  count = var.certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }

  tags = {
    Name = "${var.project}-listener-https-${var.environment}"
  }
}

# HTTPリスナー
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = var.certificate_arn != "" ? "redirect" : "forward"
    
    # 証明書がある場合はHTTPSへリダイレクト
    dynamic "redirect" {
      for_each = var.certificate_arn != "" ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    
    # 証明書がない場合は直接転送
    target_group_arn = var.certificate_arn == "" ? aws_lb_target_group.http.arn : null
  }

  tags = {
    Name = "${var.project}-listener-http-${var.environment}"
  }
}