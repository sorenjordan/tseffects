#### Toy CI Data ####
library(dynamac)

set.seed(1)
x <- rnorm(50)
dx <- dshift(x)
ldx <- lshift(dx, 1)

u <- rnorm(50)
y <- dy <- rep(NA, length(x))

y[1:2] <- rnorm(2)

for(i in 3:length(dy)) {
  dy[i] <- dx[i]*rnorm(1, 3, 1) + ldx[i]*rnorm(1, 0.5, 0.3) + u[i]
  y[i] <- y[i-1]*1.1 + dy[i]
}

dy <- dshift(y)
d2y <- dshift(dy)


ldy <- lshift(dy, 1)
ld2y <- lshift(d2y, 1)

small2 <- data.frame(x = x, dx = dx, ldx = ldx, 
                     y = y, dy = dy, ldy = ldy,
                     d2y = d2y, ld2y = ld2y)

small2 <- small2[5:50,]

save(small2, file = 'small2.rda')
