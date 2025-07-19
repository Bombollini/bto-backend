import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { TokenModule } from './token/token.module';
import { CommonModule } from './common/common.module';

@Module({
  imports: [AuthModule, UserModule, TokenModule, CommonModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
